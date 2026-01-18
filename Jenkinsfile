pipeline {
    agent any
    
    environment {
        // These 4 must exist as Secret Text or Username/Password in Jenkins
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        
        // This is the one causing the current error
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
                // We pass the SSH key variable here
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
