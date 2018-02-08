echo "{ \"execute\": \"qmp_capabilities\" } 
      { \"execute\": \"set-mplm-migration\", 
                     \"arguments\": 
                       { \"enable\": true, 
                         \"firstnondirty\": true, 
                         \"intervaltime\": 3, 
                         \"relaxlivemig\": true,  
                         \"dirtypercents\": 50 } }" | sudo socat UNIX-CONNECT:./qmp-sock-9666 STDIO 
