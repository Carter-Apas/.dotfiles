function sf
    set -l target (find ~ -maxdepth 4 \( -name node_modules -o -name Library -o -path '*/.Trash' \) -prune -o -print | fzf)

    if test -n "$target"
        if test -f "$target"
            cd (dirname "$target")
        else
            cd "$target"
        end
    end
end
