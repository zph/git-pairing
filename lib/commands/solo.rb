desc 'resets git author to single global user: $git pair solo'
command :solo do |c|
  c.action do |global_options,options,args|
    `git config --unset-all user.name`
    `git config --unset-all user.email`
    `git config --unset-all user.initials`
    `git config --remove-section user`
  end
end

