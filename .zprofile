[[ "Darwin" == $(uname) ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

export VIRTUAL_ENV_DISABLE_PROMPT="true"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init - zsh)"
export PYTHONPATH=.

export PATH="${HOME}/.local/bin:$PATH"
export MANPAGER="vim +MANPAGER --not-a-term -"

export STARSHIP_LOG="error"
