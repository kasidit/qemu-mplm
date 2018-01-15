echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"migrate-incoming\", \"arguments\": { \"uri\": \"tcp::8698\" } }" | socat UNIX-CONNECT:./qmp-sock-9666 STDIO 
