Param(
    [Parameter(Mandatory)]
    [string]$KeyVaultName,
	[Parameter(Mandatory)]
    [string]$Subscription,
	[Parameter(Mandatory)]
    [string]$ResourceGroup,
	[Parameter(Mandatory)]
    [string]$KeyVaultLocation
)

# Create a new dev key vault if it does not exists
if(-not (az keyvault show --name $KeyVaultName --subscription $Subscription)){
	az keyvault create --name $KeyVaultName --location $KeyVaultLocation --resource-group $ResourceGroup --subscription $Subscription
}

# wait for some time while azure create this 
while (-not (az keyvault show --name $KeyVaultName --subscription $Subscription)){
	Start-Sleep -s 10
}

# This script assumes that you are already logged into azure
# Read all the keys from this key vault and save them in a variable
$secrets = az keyvault secret list --vault-name $KeyVaultName | ConvertFrom-Json

# Loop through this list and process each secret
foreach($secret in $secrets){
	# Get the id of the secret
	$id = $secret.id
	# To create new secret, you'll need name
	$name = $id.SubString($id.LastIndexOf("/")+1)

	# $secret variable still does not contain value, so need to read that again
	$secretWithValue = $secretValue = az keyvault secret show --id $id | ConvertFrom-Json
	$value = $secretWithValue.value

	Write-Host $id
	Write-Host $value
	Write-Host "-----------------------------------------------------------"

	# Time to create new secret in the new key vault
	az keyvault secret set --name $name --vault-name $KeyVaultName --value $value
	Start-Sleep -s 2
}