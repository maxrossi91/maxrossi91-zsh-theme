#load colors
autoload colors && colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'  #wrap colours between %{ %} to avoid weird gaps in autocomplete
    eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval RESET='%{$reset_color%}'

# Function that gets executed before a command is executed
function preexec {
	_last_command_start_time=$SECONDS
}

# Function that gets executed before the prompt is displayed
precmd(){
    local return_value=$? hours minutes seconds execution_time command_status="%F{green} ok "

	if [[ -n $_last_command_start_time ]]; then
		execution_time=$((SECONDS - _last_command_start_time))
		unset _last_command_start_time
		
		if ((return_value != 0)); then
			command_status="%F{red} fail %F{blue}status %F{yellow}$return_value "
		fi

		if ((execution_time >= 3600)); then
			hours=" $((execution_time / 3600))h"
		fi
	
		if ((execution_time >= 60)); then 
			minutes=" $((execution_time % 3600 / 60))m"
		fi

		if ((execution_time > 1)); then
			seconds=" $((execution_time % 60))s"
		fi	
	fi	
	
	# Set right prompt
	RPROMPT="%F{blue}[%F{magenta}$hours$minutes$seconds$command_status%F{blue}]%f"

    print -Pr "┌─[%(?:${GREEN}:${RED})%n${RESET}][${GREEN}%m${RESET}][${BLUE}$(ipconfig getifaddr en0)${RESET}][${CYAN}%*${RESET}][ $(git_prompt_info)$(git_prompt_status)${RESET}]"
}

PROMPT='└─[${YELLOW}%3~${RESET}]'
# PROMPT='┌─[%(?:${GREEN}:${RED})%n${RESET}][${GREEN}%m${RESET}][${BLUE}$(ipconfig getifaddr en0)${RESET}][${CYAN}%D %*${RESET}][$(git_prompt_info)$(git_prompt_status)${RESET}]
# └─[${YELLOW}%3~${RESET}]'

# PROMPT="%(?:%{$fg_bold[blue]%}➜ :%{$fg_bold[red]%}➜ )"
# PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✗"
# ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✈"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ✭"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%} ✱"