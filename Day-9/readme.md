This project involves deploying an tetris game
on azure virtual machine scale set.It makes use of subnets,Load balancer,Nat to simulate an secure,scalable and reliable deployment.
here's a small layout to understand

Resource Group
     |
Virtual Network
     |
LoadBalancer ->Connected to an Public Ip (to access the app from outside the private network)   
     |
   Subnet  ->Connected to an NSG and a NAT to allow Load Balancer access the VMs  
     |
    VMSS  -> with an autoscale resource that helps to scale the app when loaded (settings are kept default)

There are a lot of things I learned through this,they are: 
1) Associations i.e linking two or more resources
2) Need of a NAT when implementing subnets
3) How to implement a autoscale res and need of subnets
