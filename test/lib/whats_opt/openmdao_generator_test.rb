require 'test_helper'
require 'whats_opt/openmdao_generator'
require 'tmpdir'

class OpenmdaoGeneratorTest < ActiveSupport::TestCase

  def setup
    @mda = analyses(:cicav)
    @ogen = WhatsOpt::OpenmdaoGenerator.new(@mda)
  end
    
  test "should generate openmdao component for a given discipline in mda" do
    Dir.mktmpdir do |dir|
      disc = @mda.disciplines[0]
      filepath = @ogen._generate_discipline disc, dir
      assert File.exists?(filepath)
      assert_match /(\w+)_base\.py/, filepath
    end
  end
  
  test "should generate openmdao process for an mda" do
    Dir.mktmpdir do |dir|
      filepath = @ogen._generate_mda dir
      assert File.exists?(filepath)
    end
  end
  
  test "should maintain a list of generated filepaths" do
    Dir.mktmpdir do |dir|
      filepath = @ogen._generate_mda dir
      basenames = @ogen.genfiles.map {|fp| File.basename(fp)}.sort
      expected = ["aerodynamics.py", "aerodynamics_base.py", "cicav.py", 
                  "cicav_base.py", "geometry.py", "geometry_base.py", 
                  "run_analysis.py", "run_doe.py", "run_optimization.py", "run_screening.py"]
      assert_equal expected, basenames
    end
  end 
  
  test "should generate openmdao mda zip file" do
    zippath = Tempfile.new('test_mda_file.zip')
    File.open(zippath, 'w') do |f|
      content, _ = @ogen.generate
      f.write content
    end
    assert File.exists?(zippath)
    Zip::File.open(zippath) do |zip|
      zip.each do |entry|
        assert entry.file?
        assert entry.get_input_stream.read =~
          Regexp.new(Regexp.escape('generated by WhatsOpt'), Regexp::MULTILINE)
      end
    end
  end 

  test "should generate openmdao mda zip base files" do
    zippath = Tempfile.new('test_mda_file.zip')
    File.open(zippath, 'w') do |f|
      content, _ = @ogen.generate(only_base=true)
      f.write content
    end
    assert File.exists?(zippath)
    Zip::File.open(zippath) do |zip|
      zip.each do |entry|
        assert_match /_base\.py|run_\w+\.py/, entry.name
      end
    end
  end 

  test "should run openmdao check and return true when valid" do
    ok, log = @ogen.check_mda_setup
    assert ok  # ok even if discipline without connections
    #assert_empty log
  end

  test "should run openmdao check and return false when invalid" do
    mda = analyses(:fast)
    ogen2 = WhatsOpt::OpenmdaoGenerator.new(mda)
    ok, log = ogen2.check_mda_setup
    refute ok  # check raises a runtime error
    assert_match /Error: Variable name .* already exists/, log.join(' ')
  end

  test "should use init value for independant variables" do
    var = variables(:varx1_out)
    zippath = Tempfile.new('test_mda_file.zip')
    File.open(zippath, 'w') do |f|
      content, _ = @ogen.generate
      f.write content
    end
    assert File.exists?(zippath)
    Zip::File.open(zippath) do |zip|
      zip.each do |entry|
        if entry.name =~ /cicav_base\.py/
          assert entry.get_input_stream.read=~
            Regexp.new(Regexp.escape("indeps.add_output('x1', 3.14)"), Regexp::MULTILINE)
        end
      end
    end
  end
  
end