require 'socket'
require 'whats_opt/openmdao_generator'
require 'whats_opt/sqlite_case_importer'


class Operation < ApplicationRecord
	
  CAT_RUNONCE = :analysis
  CAT_OPTIMISATION = :optimization 
  CAT_SCREENING = :screening
  CAT_DOE = :doe 
  CATEGORIES = [CAT_RUNONCE, CAT_OPTIMISATION, CAT_DOE, CAT_SCREENING]
  
  TERMINATION_STATUSES = %w(DONE, FAILED, KILLED)
  STATUSES = %w(PENDING, RUNNING)+TERMINATION_STATUSES
    
  BATCH_COUNT=10  # nb of log lines processed together
  LOGDIR=File.join(Rails.root, 'upload/logs')
    
  belongs_to :analysis
  has_many :options, :dependent => :destroy
  accepts_nested_attributes_for :options, reject_if: proc { |attr| attr['name'].blank? }, allow_destroy: true  
  
	has_many :cases, :dependent => :destroy
	has_one :job, :dependent => :destroy
	
  validates :name, presence: true, allow_blank: false

  scope :in_progress, ->(analysis) { Operation.where(analysis: analysis).left_outer_joins(:cases).where(cases: {operation_id: nil}) }
  scope :done, ->(analysis) { Operation.where(analysis: analysis).left_outer_joins(:cases).where.not(cases: {operation_id: nil}).uniq }
	
	def self.build_operation(mda, ope_attrs)
	  operation = mda.operations.build(ope_attrs.except(:cases))
	  operation._build_cases(ope_attrs[:cases]) if ope_attrs[:cases]
    if ope_attrs[:cases]
      operation.build_job(status: 'DONE', pid: -1, log: "")
    else
      operation.build_job(status: 'PENDING', pid: -1, log: "")
    end
	  operation
	end

  def to_plotter_json
    adapter = ActiveModelSerializers::SerializableResource.new(self)
    adapter.to_json
  end
   
  def category
    case driver
    when "runonce"
      'analysis'
    when /optimizer/
      'optimization'
    when /morris/
      'screening'
    else
      'doe'
    end 
   end
   
  def nb_of_points
    cases[0]&.nb_of_points || 0
  end
   
  def option_hash
    options.map{|h| [h['name'].to_sym, h['value']]}.to_h
  end
	
	def update_operation(ope_attrs)
	  if (ope_attrs[:options_attributes])
      ope_attrs[:options_attributes].each do |opt|
        opt[:value] = opt[:value].to_s
      end
	  end
	  self.update(ope_attrs.except(:cases))
    if ope_attrs[:cases]
      self._update_cases(ope_attrs[:cases])
      self._set_upload_job_done
    end
  end

  def perform
    ogen = WhatsOpt::OpenmdaoGenerator.new(self.analysis, self.host, self.driver, self.option_hash)
    sqlite_filename = File.join(Dir.tmpdir, "#{SecureRandom.urlsafe_base64}.sqlite")
    tmplog_filename = File.join(Dir.tmpdir, "#{SecureRandom.urlsafe_base64}.log")
    FileUtils.touch(tmplog_filename)  # ensure logfile existence
    Rails.logger.info sqlite_filename
    job = self.job || self.create_job(status: 'PENDING', pid: -1, log: "")
    job.update(status: :RUNNING, sqlite_filename: sqlite_filename, started_at: Time.now, ended_at: nil, log: "", log_count:0)

    Dir.mktmpdir("sqlite") do |dir|
      lines = []
      status = ogen.monitor(self.category, sqlite_filename) do |stdin, stdouterr, wait_thr|
        Rails.logger.info "JOB STATUS = RUNNING"
        job.update(status: :RUNNING, pid: wait_thr.pid)
        stdin.close
        dump_count=0 
        while line = stdouterr.gets
          lines << line
          if lines.count%BATCH_COUNT==0
            if dump_count<10*BATCH_COUNT
              job.update_column(:log, job.log << lines.join)
              dump_count += BATCH_COUNT
            else
              File.open(tmplog_filename, 'a') { |f| f << job.log }                
              job.update_columns(log: lines.join, log_count: job.log_count+11*BATCH_COUNT)
              dump_count = 0
            end  
            lines = []
          end
        end
        job.update_columns(log: (job.log << lines.join), log_count: job.log_count+dump_count+lines.count)
        wait_thr.value
      end
      File.open(tmplog_filename, 'a') { |f| f << job.log }
      Rails.logger.info "Log line count = #{job.log_count}"
      self._update_on_termination(status)
    end
    logfile = File.join(LOGDIR, "ope_#{self.id}.log")
    FileUtils.copy(tmplog_filename, logfile)
    last_lines = `tail -n 200 #{logfile}` 
    job.update_columns(log: last_lines, log_count: [0, job.log_count-200].max)
  end
  
  def _update_on_termination(status)
    if status.success?
      if self.driver == "runonce"
        Rails.logger.info "JOB STATUS = DONE"          
        self.job.update(status: :DONE, ended_at: Time.now)
        self.update(cases: [])
      else
        # upload
        self._upload
      end 
    else
      Rails.logger.info "JOB STATUS = FAILED"
      job.update(status: :FAILED, ended_at: Time.now)
    end
  end
  
  def _upload
    sqlite_filename = self.job.sqlite_filename
    Rails.logger.info "About to load #{sqlite_filename}"
    importer = WhatsOpt::SqliteCaseImporter.new(sqlite_filename)
    operation_params = {cases: importer.cases_attributes}
    self.update_operation(operation_params)
    self.save!
    #self.set_upload_job_done
    #Rails.logger.info "Cleanup #{sqlite_filename}"
    Rails.logger.info "Cleanup DISABLED"
    #File.delete(sqlite_filename)
  end
    
  def _set_upload_job_done
    if self.job
      self.job.update(status: 'DONE', pid: -1, log: self.job.log + "Data uploaded\n", ended_at: Time.now)
    else # wop upload
      self.create_job(status: 'DONE', pid: -1, log: "Data uploaded\n", started_at: Time.now, ended_at: Time.now)
    end
  end
	
  def _build_cases(case_attrs)
    var = {}
    case_attrs.each do |c|
      vname = c[:varname]
      var[vname] ||= Variable.where(name: vname)
                            .joins(discipline: :analysis)
                            .where(analyses: {id: self.analysis.id})
                            .take
      self.cases.build(variable_id: var[vname].id, coord_index: c[:coord_index], values: c[:values])
    end     
  end
	
  def _update_cases(case_attrs)
    self.cases.map(&:destroy)
    _build_cases(case_attrs)
  end
  
end