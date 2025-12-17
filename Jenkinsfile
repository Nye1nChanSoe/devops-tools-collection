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

        stage("Deploy") {
            steps {
                sshagent(credentials: ['secret-key']) {
                    sh '''

                        mkdir -p ~/.ssh
                        chmod 700 ~/.ssh
                        ssh-keyscan -H docker >> ~/.ssh/known_hosts

                        ssh laborant@docker '
                            docker pull ttl.sh/myapp:2h &&
                            docker rm -f myapp || true &&
                            docker run -d \
                            --name myapp \
                            -p 4444:4444 \
                            ttl.sh/myapp:2h
                        '
                    '''
                }
            }
        }
    }
}