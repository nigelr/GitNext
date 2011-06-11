require "git"

class GitNext

  CONFIG_FILE = "/.git/gitnext.config"

  def self.config_save_position value
    File.open(@current_path + CONFIG_FILE, "w") { |f| f.write value }
  end

  def self.run current_path, args=[]
    @current_path = current_path

    git = Git.open @current_path

    if File.exist?(@current_path + CONFIG_FILE)
      if args == "top"
#        git.checkout "master"

        config_save_position 0
      else
        position = File.read(@current_path + CONFIG_FILE).to_i
        position -=1
        git.checkout "master~#{position}"
        config_save_position position
      end
    else
      git_log = git.log.map(&:sha)
      git.checkout git_log.last
      config_save_position git_log.length-1
    end
  end
end