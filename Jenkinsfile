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

    stage("Terraform Apply") {
      steps {
        sshagent(credentials: ['ec2-ssh']) {
          sh '''
            # extract public key from ssh-agent
            ssh-add -L > pubkey.txt

            terraform apply -auto-approve \
              -var="ssh_public_key=$(cat pubkey.txt)"
          '''
        }
      }
    }

    stage("Show Public IP") {
      steps {
        sh 'terraform output public_ip'
      }
    }
  }
}
