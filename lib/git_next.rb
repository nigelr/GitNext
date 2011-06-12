require "rubygems"
require "git"

class GitNext

  CONFIG_FILE = "/.git/gitnext.config"

  def self.run current_path, args=[]
    @current_path = current_path
    if File.exists? File.join @current_path, ".git"
      @git = Git.open @current_path

      if File.exist?(@current_path + CONFIG_FILE)
        if args == "top"
          puts "Moving to Top"
          go_to 0
        elsif args == "prev"
          position = config_read_position
          go_to position + 1 if position < get_repo_length
        elsif args == "bottom"
          puts "Moving to Bottom"
          go_to get_repo_length
        else # next
          puts "Moving to Next"
          position = config_read_position
          go_to position - 1 if position > 0
        end
      else
        go_to get_repo_length
      end
    else
      puts "Not a git directory"
    end
  end

  private

  def self.config_save_position value
    File.open(@current_path + CONFIG_FILE, "w") { |f| f.write value }
  end

  def self.config_read_position
    File.read(@current_path + CONFIG_FILE).to_i
  end

  def self.get_repo_length
    #TODO clean this
    current_postion = @git.log.first.sha
    @git.checkout "master"
    ret = @git.log.map(&:sha).length - 1
    @git.checkout current_postion
    ret 
  end

  def self.go_to position
    @git.checkout "master#{"~#{position}" if position > 0}"
    config_save_position position
  end
  
end