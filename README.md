# INTRO 

Share code authorship when pairing and using git/github.
Works well with my fork of promptula to show which git pair is currently
configured in a git repo.

# Features

* adds new commands to git, `git pair`, `git whoami`, and `git solo`
* changes the git config `[user] name` to list multiple commit authors, and remembers partners per repository
* maintains a list of pairing partners, so that you can specify multiple commit authors by their initials
* prompts to configure new partners as needed
* reverts back to original global settings
* compliments [promptula](http://github.com/wballard/promptula)

See help for more details and available options on the commands

```
   $ git pair -h
   $ git whoami -h
   $ git solo -h
```

# Installing

To grab the latest stable release `gem install git-pairing`

Or, clone this repo and execute the following command in your
terminal/console of choice

```
    $ gem install git-pairing 
```

# Customizing

### Tweaking Promptula Command Prompt

When promptula is installed along side git-pairing, it will display the
pairing partners configured in a repo on the command line.  Installing
promptula `promptula --install` adds a line to your
.bash_profile/.bashrc `export PROMPT_COMMAND='echo -ne $(promptula)'`.
This allows users to keep whatever prompt they have already in place,
but augments it with additional info when you are in a git repo.  By
default, the promptula info is at the beginning of your prompt.

I prefer to have the path to my cwd in my prompt with promptula info at
the end.  To do that, I simply replaced the export command created by
promptula in the .bash_profile/.bashrc with

```
    export PS1="\$(pwd) \$(promoptula) "
```

### Configuration

The first time that `git pair` is executed, it will create a config file
in the user's home directory `~/.pairs`

This is just a yaml file that you can edit manually or update via the
available commands (e.g., `git pair --add sq`).  Included in the config is
the default delimiters used when setting the pair names, email
addresses, and partner initials
into the git config.  Feel free to update these as well if the defaults
do not suit your fancy.

# Known Issues

* Does not currently work on Windows... Ubuntu and Mac OS X seem fine
* May not play entirely nicely with github since they use the commiter's 
name and email address to generate statistics and links 
* Will not play nice with [Chris Kampmeier's
git-pair](https://github.com/chrisk/git-pair) gem since it uses similar
git command syntax (namely `git pair`) 

# Building

The included Rakefile will build the git-pairing gem, e.g.,

```
   $ rake
```
