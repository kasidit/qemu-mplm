echo "{ \"execute\": \"qmp_capabilities\" } 
      { \"execute\": \"transaction\",
        \"arguments\": { \"actions\": [
           { \"type\": \"blockdev-snapshot-sync\", \"data\" : { \"device\": \"ide0-hd0\",
                                      \"snapshot-file\": \"/home/kasidit/images/mplcr_cp_${1}.ovl\",
                                      \"format\": \"qcow2\" } } ] } }" | sudo socat UNIX-CONNECT:./qmp-sock-9666 STDIO 
