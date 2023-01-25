# Very basic port scanner for a single target host. Specify ports or use preset common ports
# Not ideal for large number of ports


#Define the target IP and port range
$TargetHost = Read-Host -Prompt 'Enter the target IP address. Default:localhost - '
if ($TargetHost.Length -eq 0) {
    $TargetHost = 'localhost'
}

$options = Read-Host -Prompt 'Try common ports only (HTTP,RDP,SMB,WINRM etc) Default:Y - '
if ($options.Length -eq 0) {
    $options = 'Y'
}
if ($options.ToUpper().StartsWith('Y')) {
    
    $ports = '21,22,23,25,53,139,137,445,80,8080,443,8443,5985,5986'
    $ports = $ports -split ',' 
    
}
else {

    $ports = Read-Host -Prompt 'Enter the port range to scan (e.g. 1-1000) '
    #Create a list of ports to scan
    $ports = $ports -split '-' 
    $ports = $ports[0]..$ports[1]
}

$table = New-Object System.Data.DataTable 
$table.Columns.Add("Port") | Out-Null 
$table.Columns.Add("PortOpen") | Out-Null 
 
#Loop through each port in the range and test for an open connection
foreach ($port in $ports) { 

    try {       
        $null = New-Object System.Net.Sockets.TCPClient -ArgumentList $TargetHost, $port
        $props = @{
            Port     = $port
            PortOpen = 'Yes'
        }
    }

    catch {
        $props = @{
            Port     = $port
            PortOpen = 'No'
        }
    }

    New-Object PsObject -Property $props
}
