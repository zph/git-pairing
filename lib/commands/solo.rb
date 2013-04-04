desc 'resets git author to single global user: $git pair solo'
command :solo do |c|
  c.action do |global_options,options,args|
    `git config --unset-all user.name > /dev/null 2>/dev/null`
    `git config --unset-all user.email > /dev/null 2>/dev/null`
    `git config --unset-all user.initials > /dev/null 2>/dev/null`
    `git config --remove-section user > /dev/null 2>/dev/null`
  end
end

