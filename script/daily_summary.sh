#!/bin/sh
export PATH=$PATH:/usr/local/sbin:/sbin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/rails/bin:/sbin/:/usr/sbin:/usr/local:

cd /var/www/sites/www.tomorrowit.com/tomorrowit/current
rake production summary:send_daily_summary