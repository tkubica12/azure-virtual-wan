# Create resource group
export rg=tomaswan-rg
az group create -n $rg -l westeurope

# Deploy whole environment (TBD)
az group deployment create -g $rg --template-file deploy.json

## Or deploy step by step
az group deployment create -g $rg --template-file linked/networks.json
az group deployment create -g $rg --template-file linked/firewall.json
az group deployment create -g $rg --template-file linked/branchesVpns.json
az group deployment create -g $rg --template-file linked/vms.json

## WAN idempotency issues - run in 3 phases (first 2 fail, but ignore that)
az group deployment create -g $rg --template-file linked/wanFirstTime.json
az group deployment create -g $rg --template-file linked/wanFirstTime.json
az group deployment create -g $rg --template-file linked/wan.json


# Go to Virtual WAN main page, download VPN site configuration file
# From file get hub IP address (Instance0) for we hub (branch fr and ne connection) and us hub (branch us connection)
az group deployment create -g $rg \
    --template-file linked/branchesConnections.json \
    --parameters weip=52.137.61.115 \
    --parameters usip=20.44.86.125

# Check communication between branches and Azure VMs
# Default username is tomas, passwork Azure12345678
export branchne=$(az network public-ip show -g $rg -n vm-branch-ne-ip --query ipAddress -o tsv)
ssh tomas@$branchne
    # ping branch-fr
    ping 10.254.1.10
    # ping branch us
    ping 10.254.2.10
    # ping standalone1 VNET
    ping 10.0.4.10
    # ssh to spoke1 VNET via firewall
    ssh tomas@10.0.2.10


# Delete
## phase 1
az group deployment create -g $rg --template-file linked/delete.json --mode Complete
## prase 2
az group delete -n $rg -y --no-wait