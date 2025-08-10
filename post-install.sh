

#!/bin/bash

# Post-installation script for additional setup tasks
# This script runs after the main setup.sh completes

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create additional configuration directories
print_success "Creating additional configuration directories..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.ssh"
mkdir -p "$HOME/Projects"
mkdir -p "$HOME/Downloads"
mkdir -p "$HOME/Documents"
mkdir -p "$HOME/.zsh/functions/Completion"

# Set up SSH config if it doesn't exist
if [ ! -f "$HOME/.ssh/config" ]; then
    print_success "Setting up basic SSH config..."
    cat > "$HOME/.ssh/config" << 'EOF'
# Default SSH configuration
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ControlMaster auto
    ControlPath ~/.ssh/master-%r@%h:%p
    ControlPersist 600

# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    Port 22
EOF
    chmod 600 "$HOME/.ssh/config"
    print_warning "Please add your SSH key to ~/.ssh/id_ed25519"
fi

# Set up Git configuration
print_success "Setting up Git configuration..."
if ! git config --global user.name >/dev/null 2>&1; then
    print_warning "Git user.name not set. Please run:"
    echo "  git config --global user.name 'Your Name'"
fi

if ! git config --global user.email >/dev/null 2>&1; then
    print_warning "Git user.email not set. Please run:"
    echo "  git config --global user.email 'your.email@example.com'"
fi

if ! git config --global init.defaultBranch >/dev/null 2>&1; then
    git config --global init.defaultBranch main
fi

# Install additional tools if available
if command_exists cargo; then
    print_success "Installing additional Rust tools..."
    cargo install bat exa fd-find
fi

if command_exists npm; then
    print_success "Installing additional Node.js tools..."
    npm install -g @fsouza/prettierd typescript-language-server dockerfile-language-server-nodejs
fi

# Set up tmux configuration
if command_exists tmux && [ ! -f "$HOME/.tmux.conf" ]; then
    print_success "Setting up tmux configuration..."
    cat > "$HOME/.tmux.conf" << 'EOF'
# Basic settings
set -g default-terminal "screen-256color"
set -g history-limit 10000
set -g mouse on
set -g renumber-windows on
set -g set-clipboard on

# Prefix key
set -g prefix C-a
unbind C-b
bind C-a send-prefix

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Better splitting
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"

# Pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Pane resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Copy mode
setw -g mode-keys vi
bind Enter copy-mode
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -in -selection clipboard"
bind -T copy-mode-vi r send -X rectangle-toggle

# Status bar
set -g status-position bottom
set -g status-bg colour234
set -g status-fg colour255
set -g status-attr dim
set -g status-left '#[fg=colour16,bg=colour254,bold] #S #[fg=colour255,bg=colour234,nobold] '
set -g status-right '#[fg=colour16,bg=colour254,bold] %Y-%m-%d %H:%M #[fg=colour255,bg=colour234,nobold] '
set -g window-status-format '#[fg=colour255,bg=colour234] #I #W '
set -g window-status-current-format '#[fg=colour16,bg=colour39] #I #W '
EOF
fi

# Set up Vim configuration
if command_exists vim && [ ! -f "$HOME/.vimrc" ]; then
    print_success "Setting up Vim configuration..."
    cat > "$HOME/.vimrc" << 'EOF'
" Basic settings
set nocompatible
filetype plugin indent on
syntax on
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,cp932,sjis
set fileformat=unix
set fileformats=unix,dos,mac

" UI settings
set number
set relativenumber
set cursorline
set showmatch
set showcmd
set ruler
set laststatus=2
set wildmenu
set showtabline=2

" Search settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab and indent settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

" Backup settings
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=~/.vim/undodir

" Mouse support
set mouse=a

" Clipboard settings
set clipboard=unnamedplus

" Auto commands
autocmd BufWritePre * %s/\s\+$//e
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType css setlocal tabstop=2 shiftwidth=2 expandtab

" Color scheme
if exists('&termguicolors')
    set termguicolors
endif
if has('nvim')
    set background=dark
    colorscheme default
else
    set background=dark
    colorscheme desert
endif

" Key mappings
let mapleader = " "
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>wq :wq<CR>
nnoremap <Leader>q! :q!<CR>
nnoremap <Leader>w! :w!<CR>
nnoremap <Leader>h <C-w>h
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>l <C-w>l
nnoremap <Leader>v <C-w>v
nnoremap <Leader>s <C-w>s
nnoremap <Leader>e <C-w>=
nnoremap <Leader>o <C-w>o
nnoremap <Leader>2 <C-w>2
nnoremap <Leader>3 <C-w>3
nnoremap <Leader>4 <C-w>4
nnoremap <Leader>5 <C-w>5
nnoremap <Leader>+ <C-w>+
nnoremap <Leader>- <C-w>-
nnoremap <Leader>> <C-w>>
nnoremap <Leader>< <C-w><
EOF
    mkdir -p "$HOME/.vim/undodir"
fi

# Create a .zshrc.mine file for custom user configurations
if [ ! -f "$HOME/.zshrc.mine" ]; then
    print_success "Creating .zshrc.mine for custom configurations..."
    cat > "$HOME/.zshrc.mine" << 'EOF'
# Add your custom configurations here
# This file is sourced after the main .zshrc

# Example custom aliases
# alias mycommand="echo hello"

# Example custom functions
# myfunction() {
#     echo "This is my custom function"
# }

# Example environment variables
# export MY_VAR="my_value"
EOF
fi

# Update PATH to include local bin directory
if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$HOME/.zshrc"; then
    print_success "Adding local bin to PATH..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Create a simple project template directory
print_success "Creating project template directory..."
mkdir -p "$HOME/Templates"
cat > "$HOME/Templates/README-template.md" << 'EOF'
# Project Name

## Description
Brief description of your project.

## Installation
Instructions for installing dependencies.

## Usage
Instructions for using the project.

## Contributing
Guidelines for contributing to the project.

## License
Information about the project license.
EOF

print_success "Post-installation setup completed!"
print_warning "Please restart your terminal or run 'source ~/.zshrc' to apply all changes."
print_warning "Don't forget to configure your Git user name and email:"
echo "  git config --global user.name 'Your Name'"
echo "  git config --global user.email 'your.email@example.com'"

