//parametros transversales de RG
param location string
param tags object = {}
param Vnet string
param ambiente string


// Parametros Virtual Machine
param Virtualmachine string
param vmSize string
param Subnet string
param Nic string
param zones array = []
param createOption string
param gallery string
param ipMethod string
param imagen string
param storage string


var VMname = 'data-${Virtualmachine}-${ambiente}-code'
var networkInterfaceName = 'data-${Nic}-${ambiente}-code'

//Definición VM 


resource vmDeployVirtualMachine 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: VMname
  location:location
  tags:tags
  zones: zones
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: createOption
        managedDisk: {
          storageAccountType: storage
        }
      }
      imageReference: {
        id: '${gallery}/images/${imagen}'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary:true
          }
          id: nicDeploy.id
        }
      ]
    }
  }
}

//Definición NIC Network Interface


resource nicDeploy 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: networkInterfaceName
  location:location
  tags:tags
  properties: {
    enableAcceleratedNetworking: true
    ipConfigurations: [
      {
        name: 'ipConfigVirtualMachine'
        properties: {
          privateIPAllocationMethod: ipMethod
          subnet: {
            id: '${Vnet}/subnets/${Subnet}'
          }
          primary:true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableIPForwarding: false
  }
}

