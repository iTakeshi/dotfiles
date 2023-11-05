#!/bin/bash -euvx

cd $PYENV_ROOT
git pull origin master

python2_latest=$(pyenv install-latest --print 2)
python3_latest=$(pyenv install-latest --print 3)

if [[ ! $(pyenv versions | grep $python2_latest) ]]; then
    pyenv install "$python2_latest"
fi

if [[ ! $(pyenv versions | grep $python3_latest) ]]; then
    pyenv install "$python3_latest"
fi

pyenv global "$python3_latest"
pyenv rehash
pip install numpy matplotlib PyQt5
