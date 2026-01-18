pipeline {
    agent any
    
    environment {
        // Mapping Jenkins credentials to Terraform-standard env variables
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/kakarlavenkatesh/terraform-azure-vm.git', branch: 'main'
            }
        }

stage('Terraform Init') {
    steps {
        // -force-copy answers "yes" to the migration prompt automatically
        sh 'terraform init -input=false -migrate-state -force-copy'
    }
}

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // This will now use the credentials to deploy the VM
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}
