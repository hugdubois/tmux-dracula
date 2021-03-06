#!/usr/bin/env bash
get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z $option_value ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

main()
{
  # set current directory variable
  current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

  # set configuration option variables
  show_powerline=$(get_tmux_option "@dracula-show-powerline" false)
  show_battery=$(get_tmux_option "@dracula-show-battery" true)
  show_cpu=$(get_tmux_option "@dracula-show-cpu" true)
  show_ram=$(get_tmux_option "@dracula-show-ram" true)
  show_gpu=$(get_tmux_option "@dracula-show-gpu" false)
  show_gram=$(get_tmux_option "@dracula-show-gram" false)
  show_disk01=$(get_tmux_option "@dracula-show-disk01" true)
  show_disk02=$(get_tmux_option "@dracula-show-disk02" true)
  show_network=$(get_tmux_option "@dracula-show-network" true)
  date_format=$(get_tmux_option "@dracula-date-format" "%Y-%m-%d %R")
  #date_format=$(get_tmux_option "@dracula-date-format" "%Y-%m-%d %R #(date +%Z)")
  #date_format=$(get_tmux_option "@dracula-date-format" "%a %m/%d %I:%M %p #(date +%Z)") 
  #date_format=$(get_tmux_option "@dracula-date-format" "%a %m/%d %R #(date +%Z)")


  # Dracula Color Pallette
  white='#f8f8f2'
  gray='#44475a'
  dark_gray='#282a36'
  light_purple='#bd93f9'
  dark_purple='#6272a4'
  cyan='#8be9fd'
  green='#50fa7b'
  orange='#ffb86c'
  red='#ff5555'
  pink='#ff79c6'
  yellow='#f1fa8c'
  
  if $show_powerline; then
      right_sep=''
      left_sep=''
  fi

  # set refresh interval
  tmux set-option -g status-interval 5

  # set clock
  tmux set-option -g clock-mode-style 12

  # set length 
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # pane border styling
  tmux set-option -g pane-active-border-style "fg=${dark_purple}"
  tmux set-option -g pane-border-style "fg=${gray}"

  # message styling
  tmux set-option -g message-style "bg=${gray},fg=${white}"

  # status bar
  tmux set-option -g status-style "bg=${gray},fg=${white}"

  if $show_powerline; then

      tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} #S|#I:#P#[fg=${green},bg=${gray}]#{?client_prefix,#[fg=${yellow}],}${left_sep} " 
      tmux set-option -g  status-right ""
      powerbg=${gray}

      if $show_battery; then
        tmux set-option -g  status-right "#[fg=${pink},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${dark_gray},bg=${pink}] #($current_dir/battery.sh)"
        powerbg=${pink}
      fi

      if $show_cpu || $show_ram || $show_gpu || $show_gram || $show_disk01 || $show_disk02; then
        tmux set-option -ga  status-right "#[fg=${orange},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${dark_gray},bg=${orange}]"

        if $show_cpu; then
          tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}]#($current_dir/cpu.sh) "
        fi

        if $show_ram; then
          tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}]#($current_dir/ram.sh) "
        fi

        if $show_gpu; then
          tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}]#($current_dir/gpu.sh) "
        fi

        if $show_gram; then
          tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}]#($current_dir/gram.sh) "
        fi

        if $show_disk01; then
          tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}]#($current_dir/disk01.sh) "
        fi

        if $show_disk02; then
          tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}]#($current_dir/disk02.sh)"
        fi

        powerbg=${orange}
      fi

      if $show_network; then
        tmux set-option -ga status-right "#[fg=${cyan},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${dark_gray},bg=${cyan}]#($current_dir/network.sh) "
        powerbg=${cyan}
      fi

      tmux set-option -ga status-right "#[fg=${dark_purple},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${white},bg=${dark_purple}]${date_format} "

      # window tabs 
      tmux set-window-option -g window-status-current-format "#[fg=${gray},bg=${dark_purple}]${left_sep}#[fg=${white},bg=${dark_purple}] #I:#W:#F #[fg=${dark_purple},bg=${gray}]${left_sep}"
  else
    tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} #S|#I:#P " 

    tmux set-option -g  status-right ""

    if $show_battery; then
      tmux set-option -g  status-right "#[fg=${dark_gray},bg=${pink}] #($current_dir/battery.sh) "
    fi

    if $show_cpu || $show_ram || $show_gpu || $show_gram || $show_disk01 || $show_disk02; then
      if $show_cpu; then
        tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}] #($current_dir/cpu.sh)"
      fi

      if $show_ram; then
        tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}] #($current_dir/ram.sh)"
      fi

      if $show_gpu; then
        tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}] #($current_dir/gpu.sh)"
      fi

      if $show_gram; then
        tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}] #($current_dir/gram.sh)"
      fi

      if $show_disk01; then
        tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}] #($current_dir/disk01.sh)"
      fi

      if $show_disk02; then
        tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}] #($current_dir/disk02.sh)"
      fi

      tmux set-option -ga  status-right "#[fg=${dark_gray},bg=${orange}] "
    fi

    if $show_network; then
      tmux set-option -ga status-right "#[fg=${dark_gray},bg=${cyan}]#($current_dir/network.sh)"
    fi

    tmux set-option -ga status-right "#[fg=${dark_purple},bg=${powerbg},nobold,nounderscore,noitalics] ${right_sep}#[fg=${white},bg=${dark_purple}] ${date_format} "

    # window tabs 
    tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I:#W:#F "

  fi
  
  tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${gray}] #I:#W:#F "
}

# run main function
main
