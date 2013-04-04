module GitPairs
  class Pairs
    # Functions for manipulating the .pairs config file
    def self.add(initials)
      #if $pairs_conf["pairs"].include?(initials)
      if self.exists?(initials)
        puts"Pairing Partner '#{initials}' already exists"
      else
        #puts "In Add"
        #ap $pairs_conf
        unless GitPairs::Pairs.exists?(initials)
          puts"Please provide info for: #{initials}"
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
          puts"Added '#{initials}' to list of available pairs"
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
