. $HOME/.sh_init

# Increase my timeout to 4 h.
TMOUT=14400

# Include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
