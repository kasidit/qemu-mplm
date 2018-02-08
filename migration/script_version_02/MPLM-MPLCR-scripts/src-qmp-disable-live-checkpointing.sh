echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"live-checkpointing-disable\" }" | sudo nc -U ./qmp-sock-9666 
