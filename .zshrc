# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/mitchelvanbever/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ruin="yarn ${1}"

if [[ -z $ZSH_THEME_CLOUD_PREFIX ]]; then
    ZSH_THEME_CLOUD_PREFIX='👻'
fi

deleteBranch() {
  if [ "$1" == "master" ] || [ "$1" == "develop" ] || [ "$1" == "release" ]; then
    echo "Won't delete $1"
  elif [ "$1" == "$(git symbolic-ref —short HEAD 2> /dev/null)" ]; then
    echo "currently on $1 can't delete it"
  else
    echo git branch -d $1
  fi
}

deleteAllBranches() {
  git for-each-ref —shell —format="ref=%(refname:short)" refs/heads | \
while read entry
do
  eval "$entry"
  deleteBranch "$ref"
done
}

alias wipeBranches=deleteAllBranches

updateBranch() {
  git checkout $1 && git fetch && git merge origin/$1
}

alias update=updateBranch

issueBranch() {
  git checkout -b issue-#$1
}

alias issue=issueBranch

newBranch() {
  git checkout -b $1
}

alias branch=newBranch

alias sesame=start-iterm-workspace

chooseDir() {
  printf "Please select folder:\n"
  select d in */; do test -n "$d" && break; echo ">>> Invalid Selection"; done
  cd "$d" && pwd && sesame
}

alias goo=chooseDir

pushBranch() {
  git push origin $(git symbolic-ref —short HEAD 2> /dev/null)
}

selectDir() {
  # Copyright (C) 2017 Ingo Hollmann - All Rights Reserved
  # Permission to copy and modify is granted under the Creative Commons Attribution 4.0 license
  # Last revised 2017-09-08

  declare -a menu=("Option 1" "Option 2" "Option 3" "Option 4" "Option 5" "Option 6")
  cur=0

  draw_menu() {
      for i in "${menu[@]}"; do
          if [[ ${menu[$cur]} == $i ]]; then
              tput setaf 2; echo " > $i"; tput sgr0
          else
              echo "   $i";
          fi
      done
  }

  clear_menu()  {
      for i in "${menu[@]}"; do tput cuu1; done
      tput ed
  }

  # Draw initial Menu
  draw_menu
  while read -sN1 key; do # 1 char (not delimiter), silent
      # Check for enter/space
      if [[ "$key" == "" ]]; then break; fi

      # catch multi-char special key sequences
      read -sN1 -t 0.0001 k1; read -sN1 -t 0.0001 k2; read -sN1 -t 0.0001 k3
      key+=${k1}${k2}${k3}

      case "$key" in
          # cursor up, left: previous item
          i|j|$'\e[A'|$'\e0A'|$'\e[D'|$'\e0D') ((cur > 0)) && ((cur--));;
          # cursor down, right: next item
          k|l|$'\e[B'|$'\e0B'|$'\e[C'|$'\e0C') ((cur < ${#menu[@]}-1)) && ((cur++));;
          # home: first item
          $'\e[1~'|$'\e0H'|$'\e[H')  cur=0;;
          # end: last item
          $'\e[4~'|$'\e0F'|$'\e[F') ((cur=${#menu[@]}-1));;
          # q, carriage return: quit
          q|''|$'\e')echo "Aborted." && exit;;
      esac
      # Redraw menu
      clear_menu
      draw_menu
  done

  echo "Selected item $cur: ${menu[$cur]}";
}

alias dir=selectDir

alias cleanse="rm -rf package-lock.json && rm -rf yarn.lock && rm -rf node_modules && yarn"

alias push=pushBranch

alias rnDebug="open rndebugger://set-debugger-loc?host=localhost&port=8081"
alias eifoon="react-native run-ios"
alias andro="react-native run-android"

alias gs="git status"
alias dedupe="npx yarn-deduplicate yarn.lock"

alias db="mongod --dbpath=/Users/mitchelvanbever/sites/data/db"

alias cmt="yarn commit"
alias xt="exit"

alias waddup="node /Users/mitchelvanbever/BlackBox/sites/waddup/build/index.js"
alias ngrok="/Users/mitchelvanbever/sites/ngrok"

PROMPT='%{$fg_bold[red]%}$ZSH_THEME_CLOUD_PREFIX %{$fg_bold[red]%}$(git_prompt_info)%{$fg_bold[red]%} % %{$reset_color%}'
RPROMPT='%{$fg_bold[red]%}%D %* % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[red]%}[%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}] %{$fg[red]%}⚡️%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[red]%}]"

source /Users/mitchelvanbever/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/mitchelvanbever/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/mitchelvanbever/.bashrc

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export REACT_EDITOR=code

export JAVA_HOME=$(/usr/libexec/java_home)

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion
source /Users/mitchelvanbever/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

eval "$(starship init zsh)"
source /Users/mitchelvanbever/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
