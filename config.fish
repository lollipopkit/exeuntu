fish_add_path ~/.local/bin
fish_add_path ~/go/bin
fish_add_path /usr/local/go/bin
fish_add_path ~/env/flutter/bin
fish_add_path ~/.bun/bin
fish_add_path ~/.cargo/bin
fish_add_path /home/linuxbrew/.linuxbrew/bin
fish_add_path /home/linuxbrew/.linuxbrew/sbin

if test -x /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

# Change to /opt/homebrew/bin/fish if using Homebrew Fish
set -x SHELL /usr/bin/fish
set -x TZ Asia/Shanghai
set -x LC_ALL en_US.UTF-8
set -x EDITOR vim
set -x FIC $HOME/.config/fish/config.fish
set -x FIH $HOME/.local/share/fish/fish_history
set -gx NVM_DIR $HOME/.nvm
set -gx BUN_INSTALL "$HOME/.bun"

if not command -q npm; and type -q nvm
    nvm install lts
    nvm use lts
end

if command -q pi; and command -q npm
    set -l pi_settings "$HOME/.pi/agent/settings.json"
    for package_source in npm:pi-models-metadata npm:pi-tab-follow-up npm:pi-autoresearch
        if not test -f $pi_settings; or not rg -q --fixed-strings "\"$package_source\"" $pi_settings
            pi install $package_source
        end
    end
end

set -g fish_greeting
set -g sponge_successful_exit_codes 0 130 255
set -g sponge_purge_only_on_exit true
set -g hydro_symbol_prompt '>'
set -g hydro_symbol_git_dirty '!'
set -gx XDG_RUNTIME_DIR "/run/user/"(id -u)
