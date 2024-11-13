pipeline {
    agent any
    environment {
        // Variables d'environnement
        SUM_PY_PATH = 'sum.py'
        DIR_PATH = '.' 
        TEST_FILE_PATH = 'test_variables.txt'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    // Construction de l'image Docker
                    bat "docker build -t imagepython ."
                }
            }
        }