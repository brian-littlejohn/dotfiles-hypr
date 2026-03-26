#!/bin/bash

pacman -Qqem > ~/dotfiles/arch-packages/package_list_aur.txt
pacman -Qqen > ~/dotfiles/arch-packages/package_list.txt
