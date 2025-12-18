pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = "ap-southeast-1"
  }

  stages {
    stage("Terraform Init") {
      steps {
        sh 'terraform init'
      }
    }

    stage("Terraform Plan") {
      steps {
        sshagent(credentials: ['ec2-ssh']) {
          sh '''
            ssh-add -L > pubkey.txt
            terraform plan -var="ssh_public_key=$(cat pubkey.txt)"
          '''
        }
      }
    }

    stage("Terraform Apply") {
      steps {
        sshagent(credentials: ['ec2-ssh']) {
          sh '''
            ssh-add -L > pubkey.txt
            terraform apply -auto-approve \
              -var="ssh_public_key=$(cat pubkey.txt)"
          '''
        }
      }
    }

    stage("Show Outputs") {
      steps {
        sh '''
          echo "Public IP: $(terraform output -raw public_ip)"
          echo "Service URL: $(terraform output -raw service_url)"
        '''
      }
    }
  }

  post {
    always {
      sh 'rm -f pubkey.txt'
    }
  }
}