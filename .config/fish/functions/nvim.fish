function nvim
  if test -f uv.lock
    echo "uv.lock found running \"uv run nvim\"..."
    uv run nvim
    return
  end
  command nvim $argv
end
