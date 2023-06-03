@echo off

CodeCoverage.exe ^
  -e .\Win64\Debug\loja_server_test.exe ^
  -m .\Win64\Debug\loja_server_test.map ^
  -dproj loja_server_test.dproj ^
  -od .\Win64\Debug ^
  -emma ^
  -meta ^
  -xml ^
  -html
  
timeout /t -1