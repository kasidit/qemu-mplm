echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"migrate\", \"arguments\": { \"uri\": \"tcp:192.168.20.3:8698\" } }" | socat UNIX-CONNECT:./qmp-sock-9666 STDIO 
