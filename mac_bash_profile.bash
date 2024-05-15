#!/usr/bin/env bash

export BASH_SILENCE_DEPRECATION_WARNING=1
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE

eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] ; then
    . "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

export PATH=$PATH:/Users/iankennedy/Library/Python/3.9/bin

# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

export OSH='/Users/iankennedy/.oh-my-bash'

OSH_THEME="90210"

completions=()
aliases=()
plugins=()

source "$OSH"/oh-my-bash.sh
