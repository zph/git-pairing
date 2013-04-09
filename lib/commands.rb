module GitPairs
  class Commands
    def self.add(conf, partners)
      partners.uniq.each do |partner|
        unless GitPairs::Helper.exists?(conf, partner)
          GitPairs::Helper.add(conf, partner)
        else
          puts ""
          puts "Pairing Partner '#{partner}' already exists"
          puts "To replace '#{partner}', first execute:  git pair rm #{partner}"
        end
      end
    end

    def self.rm(conf, partners)
      if partners.empty?
        puts ""
        Trollop::die "Please supply at least 1 set of initials"
      end
      partners.uniq.each do |partner|
        unless GitPairs::Helper.exists?(partner)
          puts"There is no pairing partner configured for: #{partner}"
        else
          GitPairs::Helper.delete(partner)
        end
      end

    end

    def self.set(conf, partners)
      if partners.empty? || partners.size < 2
        puts ""
        Trollop::die "Please supply at least 2 sets of initials"
      end

      authors = []
      partners.uniq.each do |partner|
        unless GitPairs::Helper.exists?(partner)
          GitPairs::Helper.add(partner)
        end
        #concatenate each partner's info into delimited strings
        @author =  GitPairs::Helper.fetch(conf, partner)["username"]
        authors << ["#{@author}","#{partner}"]
      end

      GitPairs::Helper.set(conf, authors)
    end
  end
end
