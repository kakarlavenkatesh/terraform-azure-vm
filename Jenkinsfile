pipeline {
  agent any

  environment {
    ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
    ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
    ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
    ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')

    TF_IN_AUTOMATION = "true"
    TF_INPUT         = "false"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main',
<<<<<<< HEAD
            url: 'https://github.com/kakarlavenkatesh/terraform-azure-vm.git'
=======
        url: 'git@github.com:kakarlavenkatesh/terraform-azure-vm.git'
>>>>>>> bb0eda3 (Add network interface and attach to VM)
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init -reconfigure'
      }
    }

    stage('Terraform Validate') {
      steps {
        sh 'terraform validate'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
  }

  post {
    failure {
      echo '❌ Terraform pipeline failed'
    }
    success {
      echo '✅ Terraform VM deployed successfully'
    }
  }
}
