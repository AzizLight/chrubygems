#       _                _
#   ___| |__  _ __ _   _| |__  _   _  __ _  ___ _ __ ___  ___
#  / __| '_ \| '__| | | | '_ \| | | |/ _` |/ _ \ '_ ` _ \/ __|
# | (__| | | | |  | |_| | |_) | |_| | (_| |  __/ | | | | \__ \
#  \___|_| |_|_|   \__,_|_.__/ \__, |\__, |\___|_| |_| |_|___/
#                              |___/ |___/
#
set -gx CHRUBYGEMS_DIR (dirname (status --current-filename))

set fish_function_path "$CHRUBYGEMS_DIR/functions" $fish_function_path
