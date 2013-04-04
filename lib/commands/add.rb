desc 'adds new pairing partners: $git pair add <user-initials-1> [<user-initials-2> ...]'
command :add do |c|
  c.action do |global_options,options,args|
    partners = ""
    if args.empty?
      list = ask("Please enter a space separated list of partner initials to configure")
      partners = list.strip.split(/ /)
    else
      partners = args
    end
    partners.uniq.each do |partner|
      unless GitPairs::Pairs.exists?(partner)
        GitPairs::Pairs.add(partner)
      else
        puts "Pairing Partner '#{partner}' already exists"
        puts"To replace '#{partner}', first execute:  git pair rm #{partner}"
      end
    end
  end
end
