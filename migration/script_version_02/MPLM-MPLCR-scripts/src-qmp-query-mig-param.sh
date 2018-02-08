echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"query-migrate-parameters\" }" | sudo nc -U ./qmp-sock-9666 
