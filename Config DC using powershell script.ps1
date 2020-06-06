## To install Active Directory role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

## To view the available module commands related to AD DS
Get-Command -Module ADDSDeployment

## The instructions said I need to first install a root domain but
## but I don't understand this part, do some more research before running this code
## also don't I need to install DNS first before doing this? 
Install-ADDSForest -DomainName “tenny.local”

## Run this command to make sure that the correct change have been made to the AD
Get-AdDomain

## If all this is succeful then you should be able to join a computer to your domain 
## look at this instructions on this webpage to make sure that this step is done correctly
## https://medium.com/@droidmlwr/install-ad-ds-dns-and-dhcp-using-powershell-on-windows-server-2016-ac331e5988a7
## Always remember that you need to restart your computer to apply this changes

## Run this command to get a list of all the computer in your domain 
## this symbol "|" is a filter. With this command what I'm saying is that get me the computers in my AD and put it in a table that only inclue DNSHostName, Enabled, Name, and SamAccountName
get-ADComputer | Format-Table DNSHostName, Enabled, Name, SamAccountName

## To add an user to the AD domain, use this command 
New-ADUser -Name mcsa -AccountPassword(Read-Host -AsSecureString AccountPassword) -PassThru | Enable-ADAccount
## With this command, you should check with the articles because the account password "read-host" make no sence 

## the DNS server should have been created when ADDS role was installed 
## to check if this role was installed used this command
Get-WindowsFeature | where {($_.name -like “DNS”)}
## also a little tip, the "$_." there's a lot of implemention to this command 
## read more about "$_." http://techgenix.com/dollar-sign-underscore-dot/

## to install DNS use this command
## skip this part if DNS role is already installed
Install-WindowsFeature DNS -IncludeManagementTools


## I still don't understand this part about what we are doing with the DNS primary zone 
## also I want to use a class A ipaddress, the defult instruction use an class c ipaddress
## then we set the network ID and file entry 
Add-DnsServerPrimaryZone -NetworkID 10.0.0.0/8 -ZoneFile “10.0.0.7.in-addr.arpa.dns”
## what is the "in-addr.arpa.dns" I would have to google this later

## now we are going to add a forwarder address for our DNS 
Add-DnsServerForwarder -IPAddress 8.8.8.8 -PassThru

## now let's test our DNS server 
Test-DnsServer -IPAddress 10.0.0.7 -ZoneName "tenny.local"


## Now let's add our DHCP role server 

## Before adding DHCP, we need to configured our VM hosting the DHCP service with a static ip address
## we need to know the interfaceindex of our VM 
## to get the interfaceindex type get-net-ipinterface
## the defult interfaceindex is 2, but you may have something different for your vm
New-NetIPAddress -InterfaceIndex 2 -IPAddress 10.0.0.2 -PrefixLength 8 -DefaultGateway 10.0.0.1

## LOL now we can beging with install the DHCP role 
## no restart needed after this command 
Install-WindowsFeature DHCP -IncludeManagementTools

## so it look like we have to create a dhcp security group
## I don't know what a dhcp security group is, so google it 
## after googleing it run this command 

netsh dhcp add securitygroups 
Restart-Service dhcpserver

### Now we need to configure the subnets, scope, and exclusions address for our DHCP
Add-DHCPServerv4Scope -Name “Employee Scope” -StartRange 10.0.0.10 -EndRange 10.0.0.30 -SubnetMask 255.0.0.0 -State Active
## now we set the lease duration for DHCP 
Set-DhcpServerv4Scope -ScopeId 10.0.0.0 -LeaseDuration 1.00:00:00

## Now we authorize our DHCP server to operate in our domain 
## use this if we build a seprate vm to host our DHCP 
## but if we have one VM that host DNS,DHCP, and AD then I idk if this would work
## might be something that you can play around with 
## I've done this before were one VM was hosting the DHCP,DNS, and AD, but my DHCP crash for some reason I still don't know 
Set-DHCPServerv4OptionValue -ScopeID 10.0.0.0 -DnsDomain tenny.local -DnsServer 10.0.0.7 -Router 10.0.0.1
## after authorize our DHCP server, then we add it to domain
Add-DhcpServerInDC -DnsName tenny.local -IpAddress 10.0.0.7


## To verify the DHCP scope use this command 
Get-DhcpServerv4Scope

## To verify the existence of this DHCP server in our DC use this command 
Get-DhcpServerInDC

## To restart the DHCP service
Restart-service dhcpserver