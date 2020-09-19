#!/bin/bash
mocp --config ~/.config/moc/config -S;
mocp --config ~/.config/moc/config -a "$@";
mocp --config ~/.config/moc/config -l "$1";
mocp --config $HOME/.config/moc/config
