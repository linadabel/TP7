pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = 'sum.py'  // Modifiez avec le chemin réel de votre script
        DIR_PATH = '.'  // Modifiez avec le chemin réel du Dockerfile
        TEST_FILE_PATH = 'test_variables.txt'  // Chemin du fichier de test
    }
    stages {
        stage('Build') {
            steps {
                script {
                    // Construction de l'image Docker
                    echo "Construction de l'image Docker"
                    sh "docker build -t pythonImage ."
                }
            }
}
}
