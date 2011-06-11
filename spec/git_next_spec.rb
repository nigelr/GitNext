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

  context "never run gitnext" do
    before { GitNext.run @sample_dir }

    it("should go to last commit") { File.read(@sample_dir + "/a_file").should == "1" }
    it("should create config file") { File.exists?(@sample_dir + "/.git/gitnext.config").should be_true }
    it("should create have value of 4") { File.read(@sample_dir + "/.git/gitnext.config").should == "3" }

    context "have run gitnext before" do
      it "should go to next version" do
        GitNext.run @sample_dir
        File.read(@sample_dir + "/a_file").should == "2"
      end
      it "a_file should have '4'"
      
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