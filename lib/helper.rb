require 'yaml/store'
require 'awesome_print'

module GitPairs
  class Helper
    # Functions for manipulating the .pairs config file

    def self.init(path_to_conf)
      # Create config if it doesn't already exist
      unless File.exists?(path_to_conf)
        Trollop::die "Please ensure that git is installed before proceeding" unless system 'git --version > /dev/null 2>/dev/null'
        puts "Initializing Git Pairing:"
        name = `git config --global --get user.name`
        initials = ""
        name.strip.downcase.split(/ /).each { |n| initials << n.split(//)[0] }
        email = `git config --global --get user.email`
        username = email.split("@")[0]
        default_conf = YAML::Store.new(path_to_conf)
        default_conf.transaction do
          default_conf["pairs"] = {"#{initials}" => {'name'=>"#{name.strip}", 'username'=>"#{username}", 'email'=>"#{email.strip}"} }
          default_conf["delimiters"] = {"name" => " / ", "initials" => " "}
        end
      end
      return YAML::load(File.open(path_to_conf))
    end

    def self.whoami
      user = `git config --get user.name`.strip
      email = `git config --get user.email`.strip
      puts " "
      puts "Git Config >"
      puts "Name: #{user}"
      puts "Email: #{email}"
      puts " "
    end

    def self.array_from_string(s)
      case s
        when self.include?(" ") then partners = s.split(' ')
        when self.include?(",") then partners = s.split(',')
        when self.include?("|") then partners = s.split('|')
        when self.include?(";") then partners = s.split(';')
        when self.include?(":") then partners = s.split(':')
        else partners << s
      end
      return partners
    end

    def self.add(conf, initials)
      #if conf["pairs"].include?(initials)
      if self.exists?(conf, initials)
        puts "Pairing Partner '#{initials}' already exists"
      else
        #puts "In Add"
        #ap conf
        unless GitPairs::Helper.exists?(initials)
          puts "Please provide info for: #{initials}"
          name = ask("Full Name: ")
          user = ask("Git Username: ")
          #just in case they supply email address
          user = user.split('@')[0]
          email = ask("Email: ")
          partner = {initials => {'name' => name, 'username' => user, 'email' => email}}
          conf["pairs"].update(partner)
          temp_conf = YAML::Store.new(CFG_FILE)
          temp_conf.transaction do
            temp_conf["pairs"] = conf["pairs"]
          end
          puts "Added '#{initials}' to list of available pairs"
        end
      end
    end

    def self.exists?(conf, initials)
      return conf["pairs"].include?(initials)
    end

    def self.fetch(conf, initials)
      return conf["pairs"][initials]
    end

    def self.delete(initials)
      #puts "in delete"
      #puts"before:"
      #ap conf
      if conf["pairs"].include?(initials)
        conf["pairs"].delete(initials)
        temp_conf = YAML::Store.new(CFG_FILE)
        temp_conf.transaction do
          temp_conf["pairs"] = conf["pairs"]
        end
      end
      #puts"after:"
      #ap conf
    end
  end
end
