echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"migrate-incoming\", \"arguments\": { \"uri\": \"cptcp::8698\" } }" | socat UNIX-CONNECT:./qmp-sock-9777 STDIO 
