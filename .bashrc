#!/usr/bin/env bash
# Mr. Ian Lindsay Kennedy's .bashrc

export BASH_SILENCE_DEPRECATION_WARNING=1
BREW_BASH="$(brew --prefix)/etc/profile.d/bash_completion.sh"
[[ -r "${BREW_BASH}" ]] && . "${BREW_BASH}"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# export PATH=$PATH:/home/ian/tools/lattice/diamond/3.12/bin/lin64
# export PATH=$PATH:/home/ian/tools/xilinx/ise/14.7/ISE_DS/ISE/bin/lin64
# export PATH=$PATH:/home/ian/tools/intel/quartuslite/22.1/quartus/bin
# export PATH=$PATH:/home/ian/tools/intel/quartuslite/22.1/questa_fse/linux_x86_64
# export PATH=$PATH:/mnt/c/Actel/Libero_v9.2/Model/win32acoem
# export PATH=$PATH:/home/ian/test_app

# alias exlmlic="echo \"export LM_LICENSE_FILE=\${LM_LICENSE_FILE}\""
# export LM_LICENSE_FILE=/home/ian/tools/lic/intel_questasim.dat
# $(exlmlic):/home/ian/tools/lic/lattice_diamond.dat
# $(exlmlic):/home/ian/tools/lic/microsemi_libero_soc.dat
# $(exlmlic):/home/ian/tools/lic/xilinx.lic

# export XILINXD_LICENSE_FILE=/home/ian/tools/lic/xilinx.lic

export XDG_CONFIG_HOME=~/.config

########################################################################
#
#   ALIAS
#
########################################################################
alias get_colors_bash="for (( i = 30; i < 38; i++ )); do \
echo -e \"\\033[0;\${i}m Normal: (0;\$i); \\033[1;\${i}m Light: (1;\${i})\"; done"
alias bond0_lic_mac="sudo sudo ip link set dev bond0 down; \
  sudo ip link set dev bond0 address 00:15:5d:9c:5b:a2 ; \
  sudo ip link set dev bond0 up"

# sudo ip link add bond0 address 00:15:5d:9c:5b:a2 type bond

# ip link add name bond0 type bond mode active-backup

# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

export OSH='${HOME}/.oh-my-bash'
OSH_THEME="90210"
completions=()
aliases=()
plugins=()
source "$OSH"/oh-my-bash.sh
