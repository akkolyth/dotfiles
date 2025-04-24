#!/bin/bash

line1='[[ $profile_already_sourced ]] && return'
line2='declare -x profile_already_sourced=1'
line3='[[ -s ~/.bashrc ]] && source ~/.bashrc'

bash_profile="$HOME/.bash_profile"

contains_line() {
    grep -qFx "$1" "$bash_profile"
}

add_lines_to_top() {
    local temp_file
    temp_file=$(mktemp "${TMPDIR:-/tmp}/bash_profile.XXXXXX")

    trap 'rm -f "$temp_file"' EXIT

    if ! contains_line "$line1"; then
        echo "$line1" >> "$temp_file"
    fi
    if ! contains_line "$line2"; then
        echo "$line2" >> "$temp_file"
    fi

    cat "$bash_profile" >> "$temp_file"

    echo $temp_file
    echo $bash_profile
    mv "$temp_file" "$bash_profile"

    trap - EXIT
}

add_line_to_bottom() {
    if ! contains_line "$line3"; then
        echo "$line3" >> "$bash_profile"
    fi
}

touch "$bash_profile"

add_lines_to_top
add_line_to_bottom