pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = 'sum.py'  // Modifiez avec le chemin réel de votre script
        DIR_PATH = '.'  // Modifiez avec le chemin réel du Dockerfile
        TEST_FILE_PATH = 'test_variables.txt'  // Chemin du fichier de test
    }
    stages {
        // Stage 1: Checkout code from GitHub
        stage('Checkout') {
            steps {
                git 'https://github.com/linadabel/TP7'  // Replace with your GitHub repo URL
            }
        }
}
