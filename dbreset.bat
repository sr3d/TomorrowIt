@echo off
mysql -e "drop database IF EXISTS marrily_development; create database if not exists marrily_development default character set 'utf8' default collate 'utf8_general_ci'" -u root
mysql -e "drop database IF EXISTS marrily_test; create database if not exists marrily_test default character set 'utf8' default collate 'utf8_general_ci'" -u root
echo Database Development and Test reset
pause