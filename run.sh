#!/bin/bash

sed -i "s/your client id here/$CLIENT_ID/g" ~barkeep/barkeep/environment.sh
sed -i "s/your client id here/$CLIENT_ID/g" ~barkeep/barkeep/environment.rb
sed -i "s/your client secret here/$SECRET/g" ~barkeep/barkeep/environment.sh
sed -i "s/your client secret here/$SECRET/g" ~barkeep/barkeep/environment.rb

/etc/init.d/mysql start

/etc/init.d/redis-server start

su - barkeep -c ". ~/.profile && cd barkeep && bin/run_app.bash"
