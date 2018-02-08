echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"quit\" }" | sudo nc -U ./qmp-sock-9666 
