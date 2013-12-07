#!/usr/local/bin/fish

function chgems --description="Gemsets without RVM"
  set -gx CHGEMS_VERSION "0.3.3"

  switch "$argv[1]"
  case "-V" "--version"
    echo "chgems $CHGEMS_VERSION"
    return
  case "-h" "--help"
    echo "usage: chgems [ROOT [COMMAND [ARGS]...]]"
    return
  end

  set -l root
  set -l cmd

  if test (count $argv) -gt 0
    set root (ruby -e "print File.expand_path('$argv[1]')")

    if not test -d "$root"
      echo "chgems: The directory '$root' does not exist"
      return 1
    end

    if test (count $argv) -gt 1
      set -e argv[1]

      set cmd $argv
    end
  else
    set root "$PWD"
    set cmd ""
  end

  # Cache the $PWD
  set -l previous_pwd "$PWD"

  /usr/bin/cd "$root"

  set -l ruby_engine_cmd "ruby -e \"puts defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'\""
  set -l ruby_version_cmd "ruby -e \"puts RUBY_VERSION\""
  set -l gem_path_cmd "ruby -e \"Gem.path.each { |directory| puts directory }\""

  set -l chgems_ruby_engine (eval "$ruby_engine_cmd")
  set -l chgems_ruby_version (eval "$ruby_version_cmd")
  set -l chgems_gem_path (eval "$gem_path_cmd")

  set -l gem_dir "$root/.gem/$chgems_ruby_engine/$chgems_ruby_version"

  set -l gem_bin_folder_path "$root"
  for dir in ".gem" "$chgems_ruby_engine" "$chgems_ruby_version" "bin"
    set gem_bin_folder_path "$gem_bin_folder_path/$dir"
    if not test -d "$gem_bin_folder_path"
      /bin/mkdir -p "$gem_bin_folder_path"
    end
  end

  set fish_user_paths "$gem_dir/bin" $fish_user_paths
  set -gx GEM_HOME $gem_dir
  set -gx GEM_PATH $gem_dir $chgems_gem_path

  set_color green
  echo "Gem isolation complete!"
  set_color normal

  if test -n "$cmd"
    set_color green
    echo "Running `$cmd` ..."
    set_color normal

    eval "$cmd"
  end

  /usr/bin/cd "$previous_pwd"
end
