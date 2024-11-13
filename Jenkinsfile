pipeline {
    agent any

    environment {
        CONTAINER_ID = ""
        SUM_PY_PATH = "sum.py"               /* Chemin vers sum.py */
        DIR_PATH = "."                       /* Répertoire contenant le Dockerfile */
        TEST_FILE_PATH = "test_variables.txt" /* Chemin vers test_variables.txt */
        DOCKER_IMAGE = "imagepython"         /* Nom de l'image Docker */
        DOCKER_CONTAINER_NAME = "pythoncontainer" /* Nom du conteneur Docker */
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
                    bat "docker build -t ${DOCKER_IMAGE} ${DIR_PATH}"
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    echo 'Running Docker container...'
                    def output = bat(script: "docker run -d --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE}", returnStdout: true)
                    def lines = output.split('\n')
                    CONTAINER_ID = lines[-1].trim()
                    echo "Container ID: ${CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    def testLines 
