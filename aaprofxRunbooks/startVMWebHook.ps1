 Param(
    [object]$WebhookData
)


#Start ARM VM from webhook
# If runbook was called from Webhook, WebhookData will not be null.
 if ($WebhookData -ne $null) {

         Write-Output "The call came from Webhook"
        $WebhookBody     =     $WebhookData.RequestBody

        $VM = ConvertFrom-Json -InputObject $WebhookBody
  
        $vmName = $VM.vmName

        Write-Output "Starting $VMName"
        $azureCreds = Get-AutomationPSCredential -Name "ProfxAzureCredential" 
        $account = Add-AzureAccount -Credential $azureCreds
        $sub = Get-AzureSubscription | where {$_.SubscriptionName -eq "BOSec360-T3"}
        $sub | Select-AzureSubscription
        $rmComtext = Add-AzureRmAccount -Credential $azureCreds -SubscriptionId $sub.SubscriptionId 
        $vm = Get-AzureRmResource | where {$_.ResourceType -like "Microsoft.*/virtualMachines" -and $_.Name -eq $vmName}
        $resource = Get-AzureRmVm -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
        $resource | Start-AzureRmVM
     }
     else
     {
        Write-Error "Runbook meant to be started only from webhook."
     }

          
          

 