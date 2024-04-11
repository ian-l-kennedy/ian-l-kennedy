#!/usr/bin/env bash

export LOGFILE=/tmp/bash_logger.log
export LOG_FORMAT='%DATE PID:%PID %SNAME%LINE%FNAME: [%LEVEL]: %MESSAGE'
export LOG_DATE_FORMAT='+%T %Z'                     # Example: 21:51:57 EST
export LOG_COLOR_DEBUG="\033[0;37m"                 # Gray
export LOG_COLOR_INFO="\033[0m"                     # White
export LOG_COLOR_NOTICE="\033[1;32m"                # Green
export LOG_COLOR_WARNING="\033[1;33m"               # Yellow
export LOG_COLOR_ERROR="\033[1;31m"                 # Red
export LOG_COLOR_CRITICAL="\033[44m"                # Blue Background
export LOG_COLOR_ALERT="\033[43m"                   # Yellow Background
export LOG_COLOR_EMERGENCY="\033[41m"               # Red Background
export RESET_COLOR="\x1b[0m"                        # Clear Colors

function DEBUG() {
    if ! [ -z ENABLE_BASH_LOGGER_DEBUG ] ; then
        LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"
    fi
}
function INFO() { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
function NOTICE() { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
function WARNING() { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
function ERROR() { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
function CRITICAL() { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
function ALERT() { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }
function EMERGENCY() { LOG_HANDLER_DEFAULT "$FUNCNAME" "$@"; }

# Outputs a log formatted using the LOG_FORMAT and DATE_FORMAT configurables
# Usage: FORMAT_LOG <log level> <log message>
# Example: FORMAT_LOG CRITICAL "My critical log"
function FORMAT_LOG() {
    local level="$1"
    local log="$2"
    local pid=$$
    local date="$(date "$LOG_DATE_FORMAT")"

    local script_name_init="${BASH_SOURCE[3]}"
    local script_name=${script_name_init}
    if [[ $script_name_init == "" ]] ; then script_name=terminal ; fi
    local func_name=" ${FUNCNAME[3]}"
    if [[ $script_name_init == "" ]] ; then func_name="" ; fi
    local line_number=" ${BASH_LINENO[2]}"
    if [[ $script_name_init == "" ]] ; then line_number="" ; fi

    local formatted_log="$LOG_FORMAT"
    formatted_log="${formatted_log/'%MESSAGE'/$log}"
    formatted_log="${formatted_log/'%LEVEL'/$level}"
    formatted_log="${formatted_log/'%PID'/$pid}"
    formatted_log="${formatted_log/'%LINE'/$line_number}"
    formatted_log="${formatted_log/'%FNAME'/$func_name}"
    formatted_log="${formatted_log/'%SNAME'/$script_name}"
    formatted_log="${formatted_log/'%DATE'/$date}"
    echo "$formatted_log\n"
}

# Calls one of the individual log functions
# Usage: LOG <log level> <log message>
# Example: LOG INFO "My info log"
function LOG() {
    local level="$1"
    local log="$2"
    local log_function_name="${!level}"
    $log_function_name "$log"
}

# All log levels call this handler
# logging behavior
# Usage: LOG_HANDLER_DEFAULT <log level> <log message>
# Example: LOG_HANDLER_DEFAULT DEBUG "My debug log"
function LOG_HANDLER_DEFAULT() {
    # $1 - level
    # $2 - message
    local formatted_log="$(FORMAT_LOG "$@")"
    LOG_HANDLER_COLORTERM "$1" "$formatted_log"
    LOG_HANDLER_LOGFILE "$1" "$formatted_log"
}

# Outputs a log to the stdout, colourised using the LOG_COLOR configurables
# Usage: LOG_HANDLER_COLORTERM <log level> <log message>
# Example: LOG_HANDLER_COLORTERM CRITICAL "My critical log"
function LOG_HANDLER_COLORTERM() {
    local level="$1"
    local log="$2"
    local color_variable="LOG_COLOR_$level"
    local color="${!color_variable}"
    log="$color$log$RESET_COLOR"
    echo -en "$log"
}

# Appends a log to the configured logfile
# Usage: LOG_HANDLER_LOGFILE <log level> <log message>
# Example: LOG_HANDLER_LOGFILE NOTICE "My critical log"
function LOG_HANDLER_LOGFILE() {
    local level="$1"
    local log="$2"
    local log_path="$(dirname "$LOGFILE")"
    [ -d "$log_path" ] || mkdir -p "$log_path"
    echo "$log" >> "$LOGFILE"
}

function REQUIRE_COMMAND () {
    if ! [ -x "$(command -v ${1})" ] ; then
        ERROR "${1} is required, but ${1} is not found on PATH."
        exit 1
    fi
}

function REQUIRE_IN_GIT () {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 ; then
        WARNING "The current directory is not part of a git repository."
        ERROR "Required to be inside repository."
        exit 1
    fi
}
