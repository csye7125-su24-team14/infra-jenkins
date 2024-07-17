# infra-jenkins

## Overview

This repository contains Terraform code to deploy Jenkins infrastructure in AWS using a custom Jenkins AMI. The infrastructure includes:

- EC2 instance running the Jenkins AMI
- VPC and networking components
- Security groups
- IAM roles and policies

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- AWS CLI configured with appropriate credentials
- Access to the custom Jenkins AMI
- Basic knowledge of Terraform and AWS

## Quick Start

1. Clone this repository:
   `git clone https://github.com/csye7125-su24-team14/infra-jenkins.git`
   `cd infra-jenkins`

2. Update the `environment/infra/terraform.tfvars` file with your specific values (see "Configuration" section below).

3. Initialize Terraform:
   ```terraform init```

4. Plan the infrastructure:
   ```terraform plan```

5. Apply the changes:
   ```terraform apply```

6. When prompted, type `yes` to confirm the creation of the resources.


## Terraform Commands

Here are some useful Terraform commands for managing your Jenkins infrastructure:

- Initialize Terraform:
  ```terraform init```

- Preview changes:
  ```terraform plan```

- Apply changes:
  ```terraform apply```

- Destroy infrastructure:
  ```terraform destroy```

## Troubleshooting

If you encounter issues:

1. Check the AWS Console for any error messages
2. Review Terraform logs
3. Ensure your AWS credentials are correct and have necessary permissions
4. Verify that the specified Jenkins AMI exists and is accessible

## License

[MIT License](LICENSE)
