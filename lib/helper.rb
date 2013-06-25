require 'yaml/store'
require 'paint'
require 'highline/import'

module GitPairs
  class Helper
    # Functions for manipulating the .pairs config file
    def self.windows?
      windows = (RUBY_PLATFORM.to_s =~ /win32|mswin|mingw|cygwin/ || RUBY_PLATFORM.to_s == 'ruby') ? true : false
      return windows
    end

    def self.git_installed?
      warning = "Please ensure that git is installed before proceeding"
      # Check if we are in a git repo
      if self.windows?
        Trollop::die warning unless system 'git --version > NUL 2>NUL'
      else
        Trollop::die warning unless system 'git --version > /dev/null 2>/dev/null'
      end
    end

    def self.git_repo?
      self.git_installed?
      warning = "Not in a git repo"
      # Check if we are in a git repo
      if self.windows?
        Trollop::die warning unless system 'git status > NUL 2>NUL'
      else
        Trollop::die warning unless system 'git status > /dev/null 2>/dev/null'
      end
    end

    def self.git_reset
      self.git_installed?
      if self.windows?
        `git config --unset-all user.name > NUL 2>NUL`
        `git config --unset-all user.email > NUL 2>NUL`
        `git config --unset-all user.initials > NUL 2>NUL`
        `git config --remove-section user > NUL 2>NUL`
      else
        `git config --unset-all user.name > /dev/null 2>/dev/null`
        `git config --unset-all user.email > /dev/null 2>/dev/null`
        `git config --unset-all user.initials > /dev/null 2>/dev/null`
        `git config --remove-section user > /dev/null 2>/dev/null`
      end
    end

    def self.init(path_to_conf)
      # Create config if it doesn't already exist
      unless File.exists?(path_to_conf)
        self.git_installed?
        puts Paint["initializing git-pairing for the first time...", :yellow]
        name = `git config --global --get user.name`
        initials = ""
        name.strip.downcase.split(/ /).each { |n| initials << n.split(//)[0] }
        email = `git config --global --get user.email`
        username = email.split("@")[0]
        default_conf = YAML::Store.new(path_to_conf)
        default_conf.transaction do
          default_conf["pairs"] = {"#{initials}" => {'name'=>"#{name.strip}", 'username'=>"#{username}", 'email'=>"#{email.strip}"} }
          default_conf["delimiters"] = {"name" => " / ", "initials" => " ", "email" => " , "}
        end
      end

      # Update older confs with recently added settings
      tmp_conf = YAML::load(File.open(path_to_conf))
      update_conf = YAML::Store.new(path_to_conf)
      update_conf.transaction do
        update_conf["delimiters"] = tmp_conf["delimiters"] || {}
        update_conf["delimiters"]["name"] = (tmp_conf["delimiters"] && tmp_conf["delimiters"]["name"]) || " / "
        update_conf["delimiters"]["initials"] = (tmp_conf["delimiters"] && tmp_conf["delimiters"]["initials"]) || " "
        update_conf["delimiters"]["email"] = (tmp_conf["delimiters"] && tmp_conf["delimiters"]["email"]) || " , "
      end

      return YAML::load(File.open(path_to_conf))
    end

    def self.whoami
      self.git_installed?
      user = `git config --get user.name`.strip
      email = `git config --get user.email`.strip
      puts ""
      puts "current git config >"
      puts Paint["Name: #{user}", :yellow]
      puts Paint["Email: #{email}", :yellow]
      puts ""
    end

    def self.add(conf, path_to_conf, initials)
      if self.exists?(conf, initials)
        puts ""
        puts Paint["Pairing Partner '#{initials}' already exists", :red]
        puts Paint["To replace '#{initials}', first execute:  git pair -d #{initials}", :yellow]
      else
        puts ""
        puts Paint["Please provide info for: #{initials}", :yellow]
        name = ask("Full Name: ")
        user = ask("Git Username: ")
        #just in case they supply email address
        user = user.split('@')[0]
        email = ask("Email: ")
        partner = {initials => {'name' => name, 'username' => user, 'email' => email}}
        conf["pairs"].update(partner)
        temp_conf = YAML::Store.new(path_to_conf)
        temp_conf.transaction do
          temp_conf["pairs"] = conf["pairs"]
        end
        puts ""
        puts Paint["Added '#{initials}' to list of available pairs", :yellow]
      end
    end

    def self.pair
      self.git_installed?
      install_with = <<jam
source ~/.git-pairing-prompt.sh
PROMPT_COMMAND=__git_pairing_prompt
jam
      confirmed = agree("Configure git-pairing bash prompt? ")
      if confirmed
        # copy shell script to user's home dir
        home = File.expand_path('~')
        `curl -o #{home}/.git-pairing-prompt.sh https://raw.github.com/glg/git-pairing/master/shell/.git-pairing-prompt.sh`
        # configure prompt
        [ "#{home}/.bash_profile", "#{home}/.bashrc" ].each do |profile|
          if File.exists? profile
            open(profile, 'a') do |f|
              f.puts install_with
            end
          end
        end
        puts ""
        puts Paint["Please re-source your bash_profile or bashrc", :yellow]
        puts Paint["(i.e., source ~/.bash_profile", :yellow]
        puts ""
        puts Paint["Feel free to edit ~/.git-pairing-prompt.sh to suit your prompt preferences", :yellow]
        puts ""
      end
    end

    def self.set(conf, authors)
      self.git_repo?
      authors.sort!
      sorted_authors = ""
      sorted_initials = ""
      sorted_emails = ""
      authors.each do |a|
        sorted_authors << a[0]
        sorted_initials << a[1]
        sorted_emails << a[2]
        if authors.index(a) < authors.size-1
          sorted_authors << conf['delimiters']['name']
          sorted_initials << conf['delimiters']['initials']
          sorted_emails << conf['delimiters']['email']
        end
        cmd_git = `git config user.name "#{sorted_authors}"`
        cmd_git = `git config user.initials "#{sorted_initials}"`
        cmd_git = `git config user.email "#{sorted_emails}"`
      end
    end

    def self.exists?(conf, initials)
      return conf["pairs"].include?(initials)
    end

    def self.fetch(conf, initials)
      return conf["pairs"][initials]
    end

    def self.delete(conf, path_to_conf, initials)
      if conf["pairs"].include?(initials)
        conf["pairs"].delete(initials)
        temp_conf = YAML::Store.new(path_to_conf)
        temp_conf.transaction do
          temp_conf["pairs"] = conf["pairs"]
        end
      end
    end
  end
end
