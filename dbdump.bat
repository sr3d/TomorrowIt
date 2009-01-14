@echo off
set models= Guest
echo Dumping data for "%models%"
ruby script/runner "[%models%].each { |model| model.to_fixture }"