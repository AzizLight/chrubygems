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

  # Check if the bin directory of the new "gemset" is already in the fish_user_path
  # This will prevent adding duplicate directories in the fish_user_path
  if not contains "$gem_dir/bin" $fish_user_paths
    set fish_user_paths "$gem_dir/bin" $fish_user_paths
  end

  set -gx GEM_HOME $gem_dir

  # Check if the new gem directory is already in the GEM_PATH
  # This will prevent adding duplicate directories in the GEM_PATH
  if not contains $gem_dir $chgems_gem_path
    # Cache the default GEM_PATH if it is not already cached
    # This will make it possible to have only one "gemset"
    # active at a time
    if test (count $DEFAULT_GEM_PATH) -eq 0
      set -gx DEFAULT_GEM_PATH $chgems_gem_path
    end

    set -gx GEM_PATH $gem_dir $DEFAULT_GEM_PATH
  end

  set_color green
  echo "Gem isolation complete!"
  set_color normal

  if test -n "$cmd"
    set_color green
    echo "Running `$cmd` ..."
    set_color normal

    eval "$cmd"
  end

  if test -f "$CHGEMS_BASE_LIST"
    set -l installed_gems (gem list --local --no-versions | sed 's/\*\{3\} LOCAL GEMS \*\{3\}//g')
    set -l base_gems (/bin/cat "$CHGEMS_BASE_LIST")

    set -l gems_to_install
    for gem in $base_gems
      if not contains $gem $installed_gems
        set gems_to_install $gems_to_install $gem
      end
    end

    if test (count $gems_to_install) -gt 0
      set_color green
      echo "Installing base gems..."
      set_color normal

      gem install $gems_to_install
    end
  end

  /usr/bin/cd "$previous_pwd"
end
