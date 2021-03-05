#!/bin/bash -euvx

python2_latest=$(pyenv install-latest --print 2)
python3_latest=$(pyenv install-latest --print 3)

if [[ ! $(pyenv versions | grep $python2_latest) ]]; then
    pyenv install "$python2_latest"
fi

if [[ ! $(pyenv versions | grep $python3_latest) ]]; then
    pyenv install "$python3_latest"
fi

if [[ $(pyenv versions | grep neovim2) ]]; then
    pyenv virtualenv-delete -f neovim2
fi

if [[ $(pyenv versions | grep neovim3) ]]; then
    pyenv virtualenv-delete -f neovim3
fi

pyenv virtualenv "$python3_latest" neovim3
pyenv global neovim3
pip install pynvim
pyenv virtualenv "$python2_latest" neovim2
pyenv global neovim2
pip2 install pynvim

pyenv global "$python3_latest"
pip install numpy matplotlib PyQt5
