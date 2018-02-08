echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"migrate-set-parameters\", \"arguments\": { \"max-bandwidth\": 100000000000000 } }" | sudo socat UNIX-CONNECT:./qmp-sock-9666 STDIO 
