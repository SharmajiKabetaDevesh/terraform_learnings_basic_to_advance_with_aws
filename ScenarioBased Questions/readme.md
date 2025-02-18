##Import of existing resources to terraform
So,Let's say we want to import existing resources to terraform for easy management
for this we can use the azure import command and bring the resources to our terraform state file.
for azure we have to use

```bash
terraform import azurerm_virtual_machine.example /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Compute/virtualMachines/machine1
```

We also have a tool name Azure terrafy that make the import much more easier.


## How to manage manual changes made by users

So to deal with it we should implement strict IAM rules on devops engineers and other team members
Stating that the engineers can modify i.e create/delete a resource they have to take the permission
of an higher authority or their managers.

So, it makes more sense and the both the members are liable for any downfall or errors.

