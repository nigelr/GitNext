require "rubygems"
require "git"

class GitNext

  CONFIG_FILE = "/.git/gitnext.config"

  def self.init
    message = "GitNext initialised"
    go_to get_repo_length
    message
  end

  def self.run current_path, args=""
    usage_message = "Usage: gitnext [help, init, prev, top, bottom]"
    @current_path = current_path
    if File.exists? File.join @current_path, ".git"
      @git = Git.open @current_path

      if File.exist?(@current_path + CONFIG_FILE)
        case args
          when "top"
            message = "Moved to top"
            go_to 0
          when "prev"
            message = "Moved to previous"
            position = config_read_position
            go_to position + 1 if position < get_repo_length
          when "bottom"
            message = "Moved to bottom"
            go_to get_repo_length
          when "init"
            message = init()
          else
            if args.to_s.empty?
              message = "Moving to Next"
              position = config_read_position
              go_to position - 1 if position > 0
              git_show = `git show --stat`.split("\n")

              [1,1,1].each {|row| git_show.delete_at row }
              git_show.pop
              message += "\n" + git_show.compact.join("\n")
            else
              message = usage_message
            end
        end
      else
        case args
          when "init"
            message = init()
          when "help"
            message = usage_message
          else
            message = "GitNext not initialised\n" + usage_message
        end
      end
    else
      message = "Not a git directory\n" + usage_message
    end
    message
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
    @git.checkout "master#{"~#{position}" if position > 0}", "--force"
    config_save_position position
  end
end