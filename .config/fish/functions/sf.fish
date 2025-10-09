function sf
  cd $(find ~ -maxdepth 4 -type d  \( -name node_modules -o -name Library -o -path ./.Trash \) -prune -o -print | fzf)
end
