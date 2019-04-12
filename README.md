# Azure Virtual WAN demo
Follow instructions in deploy.sh to deploy and test. Branches are simulated by Azure VPNs for demo purposes.

**WORK IN PROGRESS**

Architecture:
* Hub-and-spoke networks with Azure Firewall
* Standalone networks
* Azure Virtual WAN connected to all VNETs with routing via Azure Firewall into spoke networks
* Two branches simulated by Azure VPNs
* Virtual Machines in branches and networks to test connectivity

## Diagram
 ![](netDiagram.png?raw=true)