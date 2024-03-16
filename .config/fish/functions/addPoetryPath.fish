function addPoetryPath 
  set envPath $(poetry env info -e)

  if test $status -ne 0
     echo Not in poetry environment
     exit
  end

  set path $(string split -r -m1 / $envPath)[1]
  export PATH="$path:$PATH"
end
