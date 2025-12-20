pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = "true"
  }

  stages {
    stage("Terraform Init") {
      steps {
        sh 'terraform init'
      }
    }

    stage("Terraform Plan") {
      steps {
        withCredentials([
          string(
            credentialsId: 'ec2-ssh-pubkey',
            variable: 'TF_VAR_ssh_public_key'
          ),
          [
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-credentials'
          ]
        ]) {
          sh 'terraform plan'
        }
      }
    }

    stage("Terraform Apply") {
      steps {
        withCredentials([
          string(
            credentialsId: 'ec2-ssh-pubkey',
            variable: 'TF_VAR_ssh_public_key'
          ),
          [
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-credentials'
          ]
        ]) {
          sh 'terraform apply -auto-approve'
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
}
