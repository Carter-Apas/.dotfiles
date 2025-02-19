function killport
    lsof -i tcp:$argv
end
