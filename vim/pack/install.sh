#!/usr/bin/env bash

luheca_pack=~/.vim/pack/luheca/start

mkdir -p $luheca_pack
pushd $luheca_pack

git clone https://github.com/scrooloose/nerdtree
git clone https://github.com/jlanzarotta/bufexplorer
git clone https://github.com/NLKNguyen/papercolor-theme
git clone https://github.com/vim-airline/vim-airline
git clone https://github.com/vim-airline/vim-airline-themes
git clone https://github.com/vim-ruby/vim-ruby
git clone https://github.com/vim-syntastic/syntastic
git clone https://github.com/psf/black
#git -C black checkout 19.10b0
git clone https://github.com/ycm-core/YouCompleteMe

git clone https://github.com/airblade/vim-gitgutter

git clone https://github.com/tpope/vim-dadbod.git
git clone https://github.com/kristijanhusak/vim-dadbod-ui.git

popd
