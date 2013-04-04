desc 'switches pairing partners: $git pair set <user-initials-1> [<user-initials-2> ...]'
command :set do |c|
  c.action do |global_options,options,args|
    # Check if we are in a git repo
    unless system 'git status > /dev/null 2>/dev/null'
      puts"Not in a git repo"
    else
      #puts "in set"
      unless !args.empty?
        exit_now!("Wrong Number of Arguments - please provide pairing partners")
      else
        #puts "args not empty"
        #add pair to conf
        authors = []
        solo_author = ""
        solo_email = ""
        solo_initials = ""
        size = args.uniq.size
        args.uniq.each do |partner|
          unless GitPairs::Pairs.exists?(partner)
            GitPairs::Pairs.add(partner)
          end
          #puts "in concat"
          if size > 1
            #concatenate each partner's username into git config "author"
            @author =  GitPairs::Pairs.fetch(partner)["username"]
            authors << ["#{@author}","#{partner}"]
          else # exactly one author provided
            solo = GitPairs::Pairs.fetch(partner)
            solo_author =  solo["name"]
            solo_email = solo["email"]
            solo_initials = partner
          end
        end
        unless authors.empty?
          authors.sort!
          #puts"authors: #{authors}"
          sorted_authors = ""
          sorted_initials = ""
          authors.each do |a|
            sorted_authors << a[0]
            sorted_initials << a[1]
            if size > 1 && authors.index(a) < size-1
              sorted_authors << " "
              sorted_initials << " "
            end
          end
          #puts"sorted authors: #{sorted_authors}"
          cmd_git = `git config user.name "#{sorted_authors}"`
          cmd_git = `git config user.initials "#{sorted_initials}"`
          #puts"cmdout: " + cmd_git
        else
          #puts"in else"
          #puts"git config user.name #{solo_author}"
          #puts"git config user.email #{solo_email}"
          `git config user.name "#{solo_author}"`
          `git config user.email "#{solo_email}"`
          `git config user.initials "#{solo_initials}"`
        end
      end
    end
  end
end

