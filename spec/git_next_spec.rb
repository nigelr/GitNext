require "rspec"
require "git_next"

describe GitNext do

  before(:each) do
    @sample_dir = "/tmp/git_next_sample"

    if File.exists? @sample_dir
#      puts "Removing Existing sample git DIR (#{@sample_dir})"
      FileUtils::rm_rf @sample_dir
    end
#    puts "Creating sample git DIR in '#{@sample_dir}"
    `/usr/bin/tar -xf spec/fixtures/git_next_sample.tar -C /tmp`
  end

  it "should warn if not a git directory"

  context "never run gitnext" do
    before { GitNext.run @sample_dir }

    it("should go to last commit") { File.read(@sample_dir + "/file_1").should == "a" }
    it("should create config file") { File.exists?(@sample_dir + "/.git/gitnext.config").should be_true }
    it("should create have value of 4") { File.read(@sample_dir + "/.git/gitnext.config").should == "3" }

    context "have run gitnext before" do
      before { GitNext.run @sample_dir }
      it("should go to next version") { File.read(@sample_dir + "/file_1").should == "b" }
      it("config should have 2") { File.read(@sample_dir + "/.git/gitnext.config").should == "2" }
      
    end

    context "top" do
      it "should go to top commit" do
        GitNext.run(@sample_dir, "top")
        File.read(@sample_dir + "/.git/gitnext.config").should == "0"
      end
    end
  end

end


=begin
  gitnext
    options:
      top
      bottom
      prev
=end