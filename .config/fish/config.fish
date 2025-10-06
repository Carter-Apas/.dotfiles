if status is-interactive
  # Commands to run in interactive sessions can go here
  export CUDA_PATH=/opt/cuda

  # This line used to not be required but it somehow is with cuda 12.3.
  # We reported this as a bug to NVIDIA. For now, this seems like a viable
  # workaround.
  export NVCC_PREPEND_FLAGS='-ccbin /opt/cuda/bin'
end
