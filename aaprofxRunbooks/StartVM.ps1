Param(
    [parameter(Mandatory=$True)]
    [string] $vmName
)

$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationID $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$vm = Get-AzureRmResource | where {$_.ResourceType -like "Microsoft.*/virtualMachines" -and $_.Name -eq $vmName}
Start-AzureRmVM -name  $vm.Name -ResourceGroupName $vm.ResourceGroupName

