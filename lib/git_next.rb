require "git"

class GitNext

  CONFIG_FILE = "/.git/gitnext.config"

  def self.config_save_position value
    File.open(@current_path + CONFIG_FILE, "w") { |f| f.write value }
  end

  def self.config_read_position
    File.read(@current_path + CONFIG_FILE).to_i
  end

  def self.go_to_bottom(git)
    git.checkout "master"
    git_log = git.log.map(&:sha)
    git.checkout git_log.last
    config_save_position git_log.length-1
  end

  def self.run current_path, args=[]
    @current_path = current_path
    if File.exists? File.join @current_path, ".git"
      git = Git.open @current_path

      if File.exist?(@current_path + CONFIG_FILE)
        if args == "top"
          git.checkout "master"
          config_save_position 0
        elsif args == "bottom"
          go_to_bottom git
        else
          position = config_read_position - 1
          git.checkout "master~#{position}"
          config_save_position position
        end
      else
        go_to_bottom(git)
      end
    else
      puts "Not a git directory"
    end
  end
end