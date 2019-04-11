# Create resource group
export rg=tomaswan-rg
az group create -n $rg -l westeurope

# Deploy environment
az group deployment create -g $rg --template-file deploy.json

# Go to Virtual WAN, download VPN site configuration file and get hub IP address (Instance0)
az group deployment create -g $rg --template-file connections.json --parameters ip=104.45.65.206

# Check communication between branches and Azure VMs
export branchne=$(az network public-ip show -g $rg -n vm-branch-ne-ip --query ipAddress -o tsv)
ssh tomas@$branchne
    # ping branch-fr
    ping 10.254.1.10
    # ping standalone1
    ping 10.0.4.10

