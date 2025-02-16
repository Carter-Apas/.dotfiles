function deleteLocalBranches
    git fetch --prune
    set stale_branches (git branch -vv | grep ': gone]' | awk '{print $1}')
    
    if test -z "$stale_branches"
        echo "✅ No stale branches to delete."
        return
    end

    for branch in $stale_branches
        set prompt_str "❓ Delete branch '$branch'? (y/N): "
        read -P "$prompt_str" confirm
        if test "$confirm" = "y" -o "$confirm" = "Y"
            git branch -D $branch
        else
            echo "❌ Skipped '$branch'"
        end
    end
    echo "✅ Cleanup complete!"
end
