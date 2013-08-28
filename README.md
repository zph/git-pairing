# INTRO 

Share code authorship when pairing and using git/github.  Display a
customized bash prompt to show branch, pairing authors, and colorized
git status.

# Features

* adds new commands to git, `git pair`, `git whoami`, and `git solo`
* changes the git config `[user] name` to list multiple commit authors, and remembers partners per repository
* maintains a list of pairing partners, so that you can specify multiple commit authors by their initials
* prompts the user to configure new partners as needed
* reverts back to original global settings with `git solo` if no user is provided
* can display a bash prompt with useful git information

See help for more details and available options on the commands

```
   $ git pair -h
   $ git [ who | whoami ] -h
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

### Configuration

The first time that `git pair` is executed, it will create a config file
in the user's home directory `~/.pairs`

This is just a yaml file that you can edit manually or update via the
available commands (e.g., `git pair --add sq`).  Included in the config is
the default delimiters used when setting the pair names, email
addresses, and partner initials
into the git config.  Feel free to update these as well if the defaults
do not suit your fancy.

### Git-Pairing Command Prompt

git-pairing can display the pairing partners configured for a project on the
command line. This also allows you to keep track of important info when in a git repo.

Executing `git pair --prompt` adds this feature.
* shell script is copied to your home directory
* adds 2 lines to your .bash_profile/.bashrc to source a shell script
* shell script and bash_profile have default behavior that can easily be
customized by simply editing these default entries

# Known Issues

* May make githubs graphs and stats inaccurate since it relies on the commiter's 
name and email address to generate statistics and links

# Building

The included Rakefile will build the git-pairing gem, e.g.,

```
   $ rake
```
