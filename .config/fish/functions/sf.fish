function sf
  cd $(find ~ -type d -maxdepth 4 \( -name node_modules -o -name Library -o -path ./.Trash \) -prune -o -print | fzf)

end
