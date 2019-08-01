# Create an Array of key vaults
$keyVaultArray = @(
"Key-Vault-1",
"Key-Vault-2",
"Key-Vault-3"
)

# Azure login
az login

# New subscription where to clone the key-vault
$subscription = "mySubsription"
# New resource group where to clone the key-vault
$resourceGroup = "myResourceGroup"
# location of new key vault
$location = "centralus"

# Loop through this array and process each key-vault
foreach($vault in $keyVaultArray){	
	& ".\ProcessKeyVault.ps1" -KeyVaultName $vault -Subscription $subscription -ResourceGroup $resourceGroup -NewKeyVaultLocation $location
}