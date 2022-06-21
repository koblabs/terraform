### USAGE
    terraform fmt
    terraform validate

    # For Linux and MacOS
    export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
    export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY

    # For PowerShell
    $env:AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY"
    $env:AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
    
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
