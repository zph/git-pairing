require 'paint'

module GitPairs
  class Commands
    def self.add(conf, path_to_conf, partners)
      partners.uniq.each do |partner|
        GitPairs::Helper.add(conf, path_to_conf, partner)
      end
    end

    def self.rm(conf, path_to_conf, partners)
      partners.uniq.each do |partner|
        GitPairs::Helper.delete(conf, path_to_conf, partner)
      end
    end

    def self.set(conf, path_to_conf, partners)
      if partners.size < 2
        puts ""
        puts Paint["To configure pairing for this repo, supply a list of parnter initials.  E.g., 'git pair sq jo'", :yellow]
        Trollop::die "Wrong number of arguments"
      end
      authors = []
      partners.uniq.each do |partner|
        unless GitPairs::Helper.exists?(conf, partner)
          GitPairs::Helper.add(conf, path_to_conf, partner)
        end
        #concatenate each partner's info into delimited strings
        author =  GitPairs::Helper.fetch(conf, partner)
        name = author["username"]
        email = author["email"]
        authors << ["#{name}","#{partner}", "#{email}"]
      end
      GitPairs::Helper.set(conf, authors)
    end
  end
end
