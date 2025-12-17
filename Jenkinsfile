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
                sh "go build -o main main.go"
            }
        }

        stage("Deploy with Ansible") {
            steps {
                sshagent(credentials: ['secret-key']) {
                    sh '''
                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh

                        ssh-keyscan -H target >> ~/.ssh/known_hosts
                        chmod 600 ~/.ssh/known_hosts

                        ansible-playbook --inventory hosts.ini playbook.yml
                    '''
                }
            }
        }
    }
}