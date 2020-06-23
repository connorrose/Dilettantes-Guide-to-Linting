# ----------------------------------------------------------------------------------
#
# Formatting & commands inspired by Nate Landau's blog (02 JUL 2013)
#
# Sections:
# 1. Launch
# 2. Prompt & Terminal Display
# 3. ENV variables
# 4. Aliases
# 5. Git
#
# ----------------------------------------------------------------------------------

# ----------------------------
# 1. LAUNCH
# ----------------------------

# Log current date/time
echo ">> $(date)"
echo ""

# ----------------------------
# 2. PROMPT & TERMINAL DISPLAY
# ----------------------------

# Determine current Git branch for prompt
parse_branch () {
	git branch 2> /dev/null | grep -E '^\*' | sed 's/^\* /[/' | awk '{print $1"]"}' 
}

# Set working directory display depth
export PROMPT_DIRTRIM=3			# default to three
pdt() { PROMPT_DIRTRIM=$1; }		# trim to specified depth (arg1 = num)

# Set prompt colors & text
grey=$(tput setab 7)
blue=$(tput setab 4)
bold=$(tput bold)
reset=$(tput sgr0)
export PS1="\[$grey\]\[\e[1;30m\]\u\[\e[m\]\[$reset\] \[\e[0;93m\]{\w}\[$blue\]\$(parse_branch)\[$reset\] \[\e[0;93m\]\$ \[\e[m\]"

# Set ls color scheme
export CLICOLOR=1
export LSCOLORS=FxGxBxDxBxEgEdabagacad

# ---------------------------
# 3. ENV variables
# ---------------------------

export PATH="$PATH"

# --------------------------
# 4. ALIASES
# --------------------------

# Bash Profile
alias vbp="vim ~/.bash_profile"		# Open .bash_profile in Vim
alias nbp="nano ~/.bash_profile" 	# Open .bash_profile in Nano
alias sbp="source ~/.bash_profile"	# Source .bash_profile (to implement changes)
gbp() { grep -in $1 ~/.bash_profile; }	# Search bash profile & return numbered matching lines (case insensitive)

# LS commands
alias ll="ls -lh"			# Long form ls, no hidden files
alias la="ls -alh"			# Long form ls, inc. hidden files 
alias numF="echo $(ls -l | wc -l)"	# Count number of non-hidden files in current directory
alias numFA="echo $(ls -la | wc -l)"	# Count number of files, inc. hidden, in current directory

# Navigation
alias cd-="cd - > /dev/null"		# return to previous directory & discard stdout
alias ~="cd ~/"				# 'cd' to home directory
alias ..="cd .."			# Move up one directory level
alias ...="cd ../../"			# Up 2 levels
alias ..3="cd ../../../"		# Up 3 levels
alias ..4="cd ../../../../"		# Up 4 levels
alias ..5="cd ../../../../../"		# Up 5 levels
alias cc="cd ~/Desktop/Code/"	
alias imm="cd ~/Desktop/Code/Courses/Codesmith/Immersive"

alias mv="mv -i"			# Set default 'mv' behavior to prompt before overwriting
alias qfind="find . -name "		# Quickly search current directory for file by name
alias gg="exit"				# Exit terminal window
mkcd () { mkdir -p "$1" && cd "$1"; }	# Create nested directory and cd into it

# MISC--------
alias tea="tee -a"			# Abbreviate tee --append (can't let a great pun go to waste)
alias xper="chmod 777"			# Set XWR permission on a file for all users
alias py="python3"			# Shortcut for Python3

# Display fan speed and CPU temp
alias pm="sudo powermetrics -n1 -i1 -s smc | uniq -u | sed 's/^\*\*\* .*$//' | sed '1,5d' | head -n8 | sed '5,6d'"

# ------------------------
# 5. GIT
# ------------------------

alias bug="brew upgrade git"			# Update to current Git version
alias ginit="git init"				# Initialize new Git repository
alias gh="git help"				# Man pages for git sub-commands
alias gs="git status"				# Current git status
alias ggl="git log --all --graph --decorate"	# Git log graph with preferred flags
alias glo="git log --all --oneline"		# Git log with lines condensed
