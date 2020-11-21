export DOTFILESPATH="${HOME}/simontheleg/dotfiles"

ln -s -f ${DOTFILESPATH}/.vimrc ~/.vimrc
ln -s -f ${DOTFILESPATH}/.gitconfig ~/.gitconfig
ln -s -f ${DOTFILESPATH}/.zshrc ~/.zshrc
ln -s -f ${DOTFILESPATH}/starship.toml ~/.config/starship.toml
ln -s -f ${DOTFILESPATH}/init.vim ~/.config/nvim/init.vim
ln -s -f ${DOTFILESPATH}/kubie.yaml ~/.kube/kubie.yaml
ln -s -f ${DOTFILESPATH}/.tmux.conf ~/.tmux.conf
