function sf
  cd $(find ~ -type d -maxdepth 3 \( -name node_modules -o -name Library -o -path ./.Trash \) -prune -o -print | fzf)

end
