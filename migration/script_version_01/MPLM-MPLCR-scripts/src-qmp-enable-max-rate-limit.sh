echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"enable-max-migration-rate-limit\" }" | sudo nc -U ./qmp-sock-9666 
