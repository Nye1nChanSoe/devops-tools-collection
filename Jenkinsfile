pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    stages {
        stage("Test") {
            steps {
                sh "go test ./..."
            }
        }

        stage("Build") {
            steps {
                sh "go build -o main.bin main.go"
            }
        }

        stage("Deploy with Ansible") {
            steps {
                sh "ansible-playbook --inventory hosts.ini playbook.yml"
            }
        }
    }
}