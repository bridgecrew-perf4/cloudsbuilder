# cloudsbuilder
Cloudsbuilder is docker image that has most of commonly used components like Packer, Ansible, Terraform, Vault to deploy infrastructure.

### Versions

|    Name   | Version |
|-----------|---------|
| Terraform | 0.14.8  |
| Vault     | 1.6.3   |
| Packer    | 1.7.0   |
| Ansible   | 2.10.6 / 3.0.0        |

### Usage Examples:

GitLab Example

```

image:
  name: neutworks/cloudsbuilder
  entrypoint:
    - '/usr/bin/env'
    - 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

...

stages:
  - destroy
  - validate
  - plan
  - apply

...

validate:
  stage: validate
  script:
    - terraform validate

```


Drone Example 

```

- name: validate
  image: neutworks/cloudsbuilder
  environment:
    VAULT_TOKEN:
      from_secret: thetoken
    VAULT_ADDR: "https://vault.company.tld/"
  commands:
    - packer validate packer/image.json 


```

