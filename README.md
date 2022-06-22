# USAGE

## Setup

    # For Windows
    choco install terraform

    # For MacOS
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    brew update
    brew upgrade hashicorp/tap/terraform

    # For Ubuntu/Debian
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install terraform

    # For CentOS/RHEL
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install terraform

    # For Fedora
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
    sudo dnf -y install terraform

    # For Amazon Linux
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform

### Configurations

    # Configure an AWS profile with proper credentials
    aws configure --profile terraform

    # For Linux and MacOS
    export AWS_PROFILE=terraform

    # For PowerShell
    $env:AWS_PROFILE="terraform"

    # Terraform configurations
    terraform fmt
    terraform init
    terraform validate

### Add workspace

    terraform workspace new Development
    terraform workspace list

    terraform plan -out dev.tfplan
    terraform apply dev.tfplan

### Destroy workspace

    terraform workspace select Development
    terraform destroy -auto-approve

### Delete workspace

    terraform workspace show
    terraform workspace delete Development
