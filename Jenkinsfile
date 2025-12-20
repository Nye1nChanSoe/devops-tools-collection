pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = "true"
  }

  tools {
    go "1.24.1"
  }

  stages {
    stage("Terraform Init") {
      steps {
        dir('infra') {
          sh 'terraform init'
        }
      }
    }

    stage("Terraform Plan") {
      steps {
        dir('infra') {
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
    }

    stage("Terraform Apply") {
      steps {
        dir('infra') {
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
    }

    stage("Terraform Outputs") {
      steps {
        dir('infra') {
          sh '''
            echo "Public IP: $(terraform output -raw public_ip)"
            echo "Service URL: $(terraform output -raw service_url)"
          '''
        }
      }
    }

    stage("Test") {
      steps {
        sh 'go test ./...'
      }
    }

    stage("Build") {
      steps {
        sh 'GOOS=linux GOARCH=amd64 go build -o main main.go'
      }
    }

    stage("Deployment") {
      steps {
        sshagent(credentials: ['ec2-ssh-pubkey']) {
          sh '''
            EC2_IP=$(terraform output -raw public_ip)

            scp -o StrictHostKeyChecking=no main ec2-user@$EC2_IP:/home/ec2-user/main

            # systemd
            ssh ec2-user@$EC2_IP "
              sudo tee /etc/systemd/system/main.service > /dev/null <<'EOF'
              [Unit]
              Description=Go App
              After=network.target

              [Service]
              ExecStart=/home/ec2-user/main
              Restart=always
              RestartSec=5
              User=ec2-user

              [Install]
              WantedBy=multi-user.target
              EOF

              sudo systemctl daemon-reload
              sudo systemctl enable main
              sudo systemctl restart main
            "
          '''
        }
      }
    }
  }
}
