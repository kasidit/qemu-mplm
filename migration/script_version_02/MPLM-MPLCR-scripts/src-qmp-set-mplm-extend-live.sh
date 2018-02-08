echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"set-mplm-extend-live\" }" | sudo nc -U ./qmp-sock-9666 
