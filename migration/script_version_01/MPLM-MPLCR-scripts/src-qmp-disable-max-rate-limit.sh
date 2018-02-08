echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"disable-max-migration-rate-limit\" }" | sudo nc -U ./qmp-sock-9666 
