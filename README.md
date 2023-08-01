# terraform

```terraform
cd terraform/
```

## secret file
create secret.tfvars file with similar content:

```terraform
variable_a=aaaa
variable_b=bbb
```

with not very sesitive parameters, for sensible like passwords, pass them by command line after doing:

```terraform
terraform apply -var-file="secret.tfvars"
```

# ansible

Ansible can use dynamic inventory based on terraform openstack output.
In main directory:

```bash
ansible-playbook site.yaml
```

or

```bash
ansible-playbook site.yml -i inventories/production
```
