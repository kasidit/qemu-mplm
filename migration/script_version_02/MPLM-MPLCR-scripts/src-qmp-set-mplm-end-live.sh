echo "{ \"execute\": \"qmp_capabilities\" } { \"execute\": \"set-mplm-end-live\" }" | sudo nc -U ./qmp-sock-9666 
#echo '{ "execute": "quit" }' | nc -U ./qmp-sock-9666 
