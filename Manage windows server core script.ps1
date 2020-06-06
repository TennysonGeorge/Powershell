# with this lab, the purpose is to add our server core VM to our domain. You can think of a domain as a house, so with this lab it's like adding a room to our house. 
# We want to set our server core VM to see our internal and external DNS server. 
# the internal DNS server will have an IP address of 192.168.1.100 
# we will used google DNS server as our external DNS server with an IP address of 8.8.8.8
# in powershell run this command to set our DNS address 

Set-DnsClientServerAddress -InterfaceIndex "Ethernet" -ServerAddresses ("192.168.1.100", "8.8.8.8")
# this command will set both our internal and external DNS for our server core VM 

# next we want to check to make sure that our VM is configure the right way, so run this command in powershell

Get-NetIPConfiguration
# this command will show us the ipconfiguration of our server core VM 

# now we should be able to ping our domain... 
# if we can ping our domain then we will be able to add our server core VM to our domain 
# now let add our server core VM to our domain by using this command in powershell 

Add-Computer -DomainName nuggetlab.com -Credential /userd:administrator /passwordd:Pa$$w0rd
# we don't need to add the credential with the rest of the command, I need this to speed things up 
# if we just put Add-Computer -DomainName nuggetlab.com then press enter this will work just fine and it prompt us for our user name and password 


# list of command to run in powershell to add some roles and features in our server core VM from our DC 

Enter-PSSession -ComputerName Core-Nug 
Get-WindowsFeature
install-windowsfeature -name web-server, web-mgmt-service 
get-windowsfeature | Where-Object installed -EQ true 
Set-ItemProperty -Path "HKLM:\software\Microsoft\webmanagement\server" -Name "enableremotemanagement" -Value 1
Set-Service wmsvc -StartupType -automatic 
Rename-Computer -NewName web-nug -DomainCredential "nuggetlab\administrator" -Force -Restart
Exit-PSSession 
Invoke-Command -ComputerName web-nug -ScriptBlock { Get-Service w3svc, wmsvc }
Get-Service -ComputerName web-nug

# play with this command and see what other roles and features you can add to anyother server core VM in your domain  