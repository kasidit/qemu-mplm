echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"live-checkpointing-enable\" }" | sudo nc -U ./qmp-sock-9666 
