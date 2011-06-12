require "git"

class GitNext

  CONFIG_FILE = "/.git/gitnext.config"

  def self.config_save_position value
    File.open(@current_path + CONFIG_FILE, "w") { |f| f.write value }
  end

  def self.config_read_position
    File.read(@current_path + CONFIG_FILE).to_i
  end

  def self.get_repo_length
    @git.checkout "master"
    @git.log.map(&:sha).length - 1
  end

  def self.go_to position
    @git.checkout "master#{"~#{position}" if position > 0}"
    config_save_position position
  end

  def self.run current_path, args=[]
    @current_path = current_path
    if File.exists? File.join @current_path, ".git"
      @git = Git.open @current_path

      if File.exist?(@current_path + CONFIG_FILE)
        if args == "top"
          go_to 0
        elsif args == "prev"
          go_to config_read_position + 1
        elsif args == "bottom"
          go_to get_repo_length
        else
          go_to config_read_position - 1
        end
      else
        go_to get_repo_length
      end
    else
      puts "Not a git directory"
    end
  end
end