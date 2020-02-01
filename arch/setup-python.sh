#!/bin/bash -euvx

python2_latest=$(pyenv install-latest --print 2)
python3_latest=$(pyenv install-latest --print 3)
pyenv install "$python2_latest"
pyenv install "$python3_latest"

pyenv virtualenv "$python3_latest" neovim3
pyenv global neovim3
pip install pynvim
pyenv virtualenv "$python2_latest" neovim2
pyenv global neovim2
pip2 install pynvim

pyenv global "$python3_latest"
pip install pipx numpy matplotlib PyQt5
pipx install poetry
pipx install mycli
pipx install mypy
pipx install flake8
