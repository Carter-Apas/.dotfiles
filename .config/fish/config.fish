if status is-interactive
  # Commands to run in interactive sessions can go here
  export CUDA_PATH=/opt/cuda

  # This line used to not be required but it somehow is with cuda 12.3.
  # We reported this as a bug to NVIDIA. For now, this seems like a viable
  # workaround.
  export NVCC_PREPEND_FLAGS='-ccbin /opt/cuda/bin'
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/carter/miniconda3/bin/conda
    eval /home/carter/miniconda3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/home/carter/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/carter/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/home/carter/miniconda3/bin" $PATH
    end
end

# <<< conda initialize <<<

