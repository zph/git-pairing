# INTRO 

Share code authorship when pairing and using git/github.
Works well with my fork of promptula to show which git pair is currently
configured in a git repo.

# GEM 

## Features

* adds a new command to git, `git pair`
* changes the git config `[user] name` to list multiple commit authors
* maintains a list of pairing partners
* specifies multiple commit authors by their initials
* prompts to configure new partners as needed
* remembers partners per repository
* reverts back to original global settings

See help for more details on the commands

```
   $ git pair help
```

## Known Issues

* Does not play entirely nicely with github since they use the commiter's 
name and email address to generate statistics and links 
* Will not play nice with [Chris Kampmeier's git-pair](https://github.com/chrisk/git-pair) gem since they use similar
git command syntax (namely `git pair`) 
* Some intermittent weirdness on some machines where help command text
is duplicated


## Installing
To grab the latest stable release `gem install git-pairing`

Or, clone this repo and execute the following command in your
terminal/console of choice

```
    $ gem install git-pairing 
```

## Building

The included Rakefile will build the taz gem, e.g.,

```
   $ rake
```

## Configuration

The first time that `git pair` is executed, it will create a config file
in the user's home directory `~/.pairs`

This is just a yaml file that you can edit manually or update via the
available commands (e.g., `git pair add sq`).  Included in the config is
the default delimiters used when setting the pair names and initials
into the git config.  Feel free to update these as well if the defaults
do not suit your fancy.
