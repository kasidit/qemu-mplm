echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"cont\" }" | sudo nc -U ./qmp-sock-9666 
