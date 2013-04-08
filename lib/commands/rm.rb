desc 'removes one or more pairing partners: $git pair rm <user-initials-1> [<user-initials-2> ...]'
command :rm do |c|
  c.action do |global_options,options,args|
    unless args.empty?
      args.uniq.each do |partner|
        unless GitPairs::Helper.exists?(partner)
          puts"There is no pairing partner configured for: #{partner}"
        else
          GitPairs::Helper.delete(partner)
        end
      end
    else
       exit_now!("Wrong Number of Arguments - please provide at least one partner to remove")
    end
  end
end

