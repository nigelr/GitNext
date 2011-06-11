require "git"

class GitNext

  CONFIG_FILE = "/.git/gitnext.config"

  def self.run current_path, args=[]
    git = Git.open current_path

    if File.exist?(current_path + CONFIG_FILE)
      if args == "top"
#        git.checkout "master"

        File.open(current_path + CONFIG_FILE, "w") { |f| f.write 0 }
      else
        position = File.read(current_path + CONFIG_FILE).to_i
        position -=1
        git.checkout "master~#{position}"
        File.open(current_path + CONFIG_FILE, "w") { |f| f.write position }
      end
    else
      git_log = git.log.map(&:sha)
      git.checkout git_log.last
      File.open(current_path + CONFIG_FILE, "w") { |f| f.write git_log.length-1 }
    end
  end
end