# Scripts, etc

Collection of scripts I find useful as well as my bashrc.

These scripts work in conjunction with the symlinks I have setup in my
[home-mac](https://github.com/justinmills/home-mac) repository (it's private for
now...working on making it public).

## Brew

Use [homebrew](https://brew.sh/) to install a lot of things. The Brewfile in
this repo is helpful for making sure you have everything you need.

    # To check that you have everything installed properly
    brew bundle check

    # To install all dependencies
    brew bundle install

##  direnv

I have a [direnvrc](./direnv/direnvrc) script that I link to from
`~/.config/direnv` to support [poetry](https://python-poetry.org/) layouts in
python projects.

