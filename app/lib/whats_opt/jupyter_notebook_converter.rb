# frozen_string_literal: true

require "open3"

module WhatsOpt
  class JupyterNotebookConverter
    SORRY_MESSAGE = "Oops, can not convert notebook to html!"
    SORRY_MESSAGE_HTML = "<p><strong>" + SORRY_MESSAGE + "</strong></p>"

    JUPYTER = APP_CONFIG["jupyter_cmd"] || "jupyter"

    class HtmlConversionError < StandardError
    end

    def initialize(file, options = { format: :html })
      @file    = file
      @options = options
      @orig_format = ".ipynb"
      @format = options[:format]
    end

    def convert
      return File.new(@file.path) if File.extname(@file.path) != @orig_format
      return File.new(@file.path) unless @options && @options[:format]

      @basename = File.basename(@file.path, @orig_format)
      src = @file
      filename = [@basename, @format ? ".#{@format}" : ""]
      dst = Tempfile.new(filename)
      dst_path = File.dirname(dst.path)
      dst_filename = File.basename(dst.path)

      cmd = "#{JUPYTER} nbconvert --template=full --output-dir=#{dst_path} --output=#{dst_filename} #{src.path}"
      Rails.logger.info "RUN COMMAND: #{cmd}"
      ok = self.run(cmd)

      unless ok
        dst.write(SORRY_MESSAGE_HTML)
        dst.flush
      end
      dst
    end

    def run(cmd)
      ok = false
      Open3.popen2e(cmd) do |stdin, stdout_err, wait_thr|
        while line = stdout_err.gets
          Rails.logger.debug line
        end
        exit_status = wait_thr.value
        ok = exit_status.success?
      end
      ok
    end
  end
end
