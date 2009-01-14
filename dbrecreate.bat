@echo off
mysql -e "create database tomorrowit_development default character set 'utf8' default collate 'utf8_general_ci'" -u root
mysql -e "create database tomorrow_test default character set 'utf8' default collate 'utf8_general_ci'" -u root
rake db:migrate