module GitPairs
  class Pairs
    # Functions for manipulating the .pairs config file

    def self.init
      unless system 'git --version > /dev/null 2>/dev/null'
        puts "Git does not appear to be installed"
        exit_now! "Please ensure that git is installed before using git-pairing"
      else
        puts "Initializing Git Pairing:"
        name = `git config --global --get user.name`
        initials = ""
        name.strip.downcase.split(/ /).each { |n| initials << n.split(//)[0] }
        email = `git config --get user.email`
        username = email.split("@")[0]
        pstation = agree("Is this a shared pairing station? (Y/N) ", false)
        default_conf = YAML::Store.new(PAIR_CFG_FILE)
        default_conf.transaction do
          default_conf["pairs"] = {"#{initials}" => {'name'=>"#{name.strip}", 'username'=>"#{username}", 'email'=>"#{email.strip}"} }
          default_conf["delimiters"] = {"name" => " / ", "initials" => " "}
          default_conf["pair_station"] = pstation
          default_conf["override_email"] = true
        end
      end
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

    def self.add(initials)
      #if $pairs_conf["pairs"].include?(initials)
      if self.exists?(initials)
        puts "Pairing Partner '#{initials}' already exists"
      else
        #puts "In Add"
        #ap $pairs_conf
        unless GitPairs::Pairs.exists?(initials)
          puts "Please provide info for: #{initials}"
          name = ask("Full Name: ")
          user = ask("Git Username: ")
          #just in case they supply email address
          user = user.split('@')[0]
          email = ask("Email: ")
          partner = {initials => {'name' => name, 'username' => user, 'email' => email}}
          $pairs_conf["pairs"].update(partner)
          temp_conf = YAML::Store.new(CFG_FILE)
          temp_conf.transaction do
            temp_conf["pairs"] = $pairs_conf["pairs"]
          end
          puts "Added '#{initials}' to list of available pairs"
        end
      end
    end

    def self.exists?(initials)
      #puts "in exists?"
      #ap $pairs_conf
      #puts$pairs_conf["pairs"].include?(initials)
      return $pairs_conf["pairs"].include?(initials)
    end

    def self.fetch(initials)
      return $pairs_conf["pairs"][initials]
    end

    def self.delete(initials)
      #puts "in delete"
      #puts"before:"
      #ap $pairs_conf
      if $pairs_conf["pairs"].include?(initials)
        $pairs_conf["pairs"].delete(initials)
        temp_conf = YAML::Store.new(CFG_FILE)
        temp_conf.transaction do
          temp_conf["pairs"] = $pairs_conf["pairs"]
        end
      end
      #puts"after:"
      #ap $pairs_conf
    end
  end
end
