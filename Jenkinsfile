pipeline {
    agent any
    
    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        // 1. Fetch the SSH key from Jenkins Credentials (stored as Secret Text)
        SSH_KEY             = credentials('AZURE_VM_SSH_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/kakarlavenkatesh/terraform-azure-vm.git', branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false -migrate-state -force-copy'
            }
        }

        stage('Terraform Plan') {
            steps {
                // 2. PASS THE VARIABLE HERE using -var
                sh "terraform plan -var='ssh_public_key=${SSH_KEY}' -out=tfplan -input=false"
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
