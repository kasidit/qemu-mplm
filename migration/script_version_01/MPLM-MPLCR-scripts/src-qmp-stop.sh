echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"stop\" }" | sudo nc -U ./qmp-sock-9666 
