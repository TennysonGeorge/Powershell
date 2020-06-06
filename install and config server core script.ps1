# With these command we are going to config an IP address for our VM 
# in the command line type "sconfig" to give you access to the server configuration page to see and change setting to your server 
# if you type ipconfig, the VM in the lab have an IP address of 169.254 which is non routable on the internet so we going to assign the VM a routable IP address 
# Run this command in powershell 


Get-NetAdapter
New-NetIPAddress -InterfaceIndex 2 -IPAddress 192.168.1.101 -PrefixLength 24 -DefaultGateway 192.168.1.1 


# in the command line if you type ipconfig you should see the new ip address that you have assign the VM
# next we are going to assign the VM an DNS server " we are going to give this VM a google DNS server"
# if you don't know why DNS server is important, google it and read or watch some video and we can talk about it late 
# Run this command in powershell 

Set-DnsClientServerAddress -InterfaceIndex 2 -ServerAddresses ("8.8.8.8", "8.8.4.4")


# this powershell command  should set google as you DNS server 
# in the command line type ipconfig /all and you should see DNS servers as 8.8.8.8 
# then in the command line type ping 8.8.8.8 you should now have a respone 

# if you type Get-NetIPConfiguration in powershell is the same as typing ipconfig in the command line 



# The next thing we are going to do is configure the firewall for our VM
# if you type netsh (netsh = netshell ) in the command line this will get us into the netshell 
# when we are in netshell if we type "?" this will get us a list of sub-command with explanation of the command to try
# in the command line of netshell type "advfirewall" and this will get us into the firewall 
# When we are in the firewall if you type "?" this will give us a list of command options that we can do with the firewall 
# In the command line get into netshell then get into advfirewall then type "allprofiles state off" 
# "allprofiles state off" this will turn off all the fire profiles off in on our VM 
# In powershell to check if our firewall profile are off type in this command 

Get-NetFirewallProfile

# When this command is type in powershell will return a state of all three firewall: the domain, the private, and the public
# analyze the state of all three of these firewall 

# In powershell to disable or Enabled all three of these firewall use these command 

Set-NetFirewallProfile -profile domain, public, private -Enabled False
Set-NetFirewallProfile -profile domain, public, private -Enabled ture 

# TO rename for VM use this command 

Rename-Computer -NewName <name of the computer> 

# In powershell the command "$env:Computername" will show us the new name of our computer 