# Log a message with green foreground
log_green() {
    echo -e "\e[38;2;113;247;159m$1\e[0m"
}

# Log a message with green foreground
log_red() {
    echo -e "\e[38;2;237;37;78m$1\e[0m"
}

# Log a message with yellow foreground
log_yellow() {
    echo -e "\e[38;2;249;220;92m$1\e[0m"
}
