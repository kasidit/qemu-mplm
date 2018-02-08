echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"migrate\", \"arguments\": { \"uri\": \"tcp:127.0.0.1:8698\" } }" | sudo socat UNIX-CONNECT:./qmp-sock-9666 STDIO 
