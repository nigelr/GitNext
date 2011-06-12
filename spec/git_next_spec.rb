require "rspec"
require "git_next"
require "git"

describe GitNext do

  let(:sample_dir) { '/tmp/git_next_sample' }

  context "not in git repo" do
    before do
      FileUtils::rm_rf sample_dir if File.exists?(sample_dir)
      Dir.mkdir sample_dir
    end

    it("should warn if not a git directory") { lambda { GitNext.run sample_dir }.should_not raise_error }
  end

  context "in a git repo" do
    let(:file_1) { File.join(sample_dir, 'file_1') }
    let(:file_2) { File.join(sample_dir, 'file_2') }
    let(:gitnext_config) { File.join sample_dir, ".git", "gitnext.config" }

    before(:each) do
      FileUtils::rm_rf(sample_dir) if File.exists?(sample_dir)

      Dir.mkdir sample_dir
      @git = Git.init sample_dir
      File.open(file_1, "w") { |f| f.write "a" }
      @git.add(".")
      @git.commit "commit #1"
      File.open(file_1, "w") { |f| f.write "b" }
      @git.add(".")
      @git.commit "commit #2"
      File.open(file_1, "w") { |f| f.write "c" }
      File.open(file_2, "w") { |f| f.write "y" }
      @git.add(".")
      @git.commit "commit #3"
      File.open(file_1, "w") { |f| f.write "d" }
      File.open(file_2, "w") { |f| f.write "z" }
      @git.add(".")
      @git.commit "commit #4"
    end

    context "have never run gitnext" do
      before { GitNext.run sample_dir }

      it("should go to last commit") { File.read(file_1).should == "a" }
      it("should create config file") { File.exists?(gitnext_config).should be_true }
      it("should create have value of 4") { File.read(gitnext_config).should == "3" }

      context "after gitnext initialised" do
        before { GitNext.run sample_dir }
        it("should go to next version") { File.read(file_1).should == "b" }
        it("config should have 2") { File.read(gitnext_config).should == "2" }
      end

      context "should not go past top" do
        before do
          GitNext.run(sample_dir, "top")
          GitNext.run sample_dir
        end
        it("should be 0") { File.read(gitnext_config).should == "0" }
        it("should be last commit") { File.read(file_1).should == "d" }
      end

      context "should not go past bottom" do
        before do
          GitNext.run sample_dir, "bottom"
          GitNext.run sample_dir, "prev"
        end
        it("should be 3") { File.read(gitnext_config).should == "3" }
        it("should be at first") { File.read(file_1).should == "a" }
      end

      context "top" do
        before do
          @git.checkout("master~2")
          GitNext.run(sample_dir, "top")
        end

        it("should go to top commit") { File.read(gitnext_config).should == "0" }
        it("should be at master") { File.read(file_1).should == "d" }
      end
      describe "bottom" do
        before do
          @git.checkout("master~1")
          GitNext.run(sample_dir, "bottom")
        end

        it("should go to bottom commit") { File.read(gitnext_config).should == "3" }
        it("should be at last") { File.read(file_1).should == "a" }
      end
      describe "previous (prev)" do
        before do
          GitNext.run sample_dir, "top"
          GitNext.run sample_dir, "prev"
        end

        it("should go to bottom commit") { File.read(gitnext_config).should == "1" }
        it("should be at last") { File.read(file_1).should == "c" }
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