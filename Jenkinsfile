pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'imagepython'
        CONTAINER_NAME = "pythoncontainer-${BUILD_ID}"
    }
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    echo 'Building Docker image...'
                    bat 'docker build -t %DOCKER_IMAGE% .'
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    echo 'Running Docker container...'
                    def output = bat(script: "docker run -d --name %CONTAINER_NAME% %DOCKER_IMAGE%", returnStdout: true)
                    def lines = output.split('\n')
                    CONTAINER_ID = lines[-1].trim()
                    echo "Container ID: ${CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                // Ajoutez vos étapes de tests ici
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                // Ajoutez vos étapes de déploiement ici
            }
        }
    }
    post {
        always {
            script {
                echo 'Cleaning up after build...'
                bat "docker rm -f %CONTAINER_NAME% || echo Container not found."
            }
        }
    }
}

