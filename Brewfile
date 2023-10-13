#
# My Brewfile
#
# Install via:
#   cd <this directory>
#   brew bundle
#
# Make sure to keep this up to date!
#
# You can use brew bundle dump to generate an updated Brewfile anywhere and
# diff it against this one.

# My usual list
brew "bash-completion"
brew "direnv"
brew "dos2unix"
brew "git"
brew "jq"
brew "yq" # like jq, but for yaml
brew "the_silver_searcher"
brew "watch"
brew "pstree"
brew "gnupg"
brew "wget"
brew "telnet"
# For cli MFA support
brew "oath-toolkit"
# To scan qr codes to get otp secrets
brew "zbar"

# These prefer install via pkg but this gets around the admin requirements for that?
brew "awscli"
brew "amazon-ecs-cli"
brew "openjdk"

# Virtual envs
brew "nvm"
brew "pyenv"
# pipenv installed separately

# Emacs
tap "d12frosted/emacs-plus"
brew "d12frosted/emacs-plus/emacs-plus@28", args: ["with-spacemacs-icon"], link: true
# There is more instructions in the output, so you've got to do the following:
#   ln -s /opt/homebrew/opt/emacs-plus@28/Emacs.app /Applications

# Support for emacs things
# sql-mode (go to compile the sql formatter)
brew "ruby"
brew "go"
brew "goreleaser"
# ispell
brew "ispell"

# Font required by spacemacs
tap "homebrew/cask-fonts"
brew "svn"  # This font requires svn...oh my
cask "font-source-code-pro"


# Databases
brew "sqlite"
#brew "freetds"
#brew "mongocli"
#brew "mongosh"
#brew "mysql"
#brew "mysql-client"
brew "postgresql@15"  # Mostly for psql command line
#brew "unixodbc"
#tap "microsoft/mssql-release"
#brew "microsoft/mssql-release/msodbcsql17"
#brew "microsoft/mssql-release/mssql-tools"

# For Terraform
tap "hashicorp/tap"
brew "tfenv"

# Authing into AWS via jumpcloud (SSO)
brew "saml2aws"

# For manipulating images (mostly used on my home machine)
brew "imagemagick"
brew "exiftool"

# GitHub cli:
brew "gh"

# 1Password CLI
tap "1password/tap"
cask "1password-cli"
