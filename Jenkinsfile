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

        stage("Run") {
            steps {
                sh "./main.bin"
            }
        }
    }
}