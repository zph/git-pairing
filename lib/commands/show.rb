desc 'displays currently set pairing partners: $git pair show [-a | --all]'
command :show do |c|
  c.desc 'list all available configured partners'
  c.default_value false
  c.switch :all, :a

  c.action do |global_options,options,args|
    # Check if we are in a git repo
    unless system 'git status > /dev/null 2>/dev/null'
      puts"Not in a git repo"
    else
      user = `git config --get user.name`.strip
      email = `git config --get user.email`.strip
      puts " "
      puts "Git Config >"
      puts "Name: #{user}"
      puts "Email: #{email}"
    end
    # display list of configured partners
    if options[:all]
      puts " "
      puts "Pairs Config >"
      ap $pairs_conf
    end
  end
end

