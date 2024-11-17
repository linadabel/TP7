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
                    echo "Construction de l'image Docker"
                    // Construction de l'image Docker
                    bat "docker build -t imagepython ."
                }
            }
        }
    stage('Run') {
            steps {
                script {
                    bat 'docker rm -f python-container || true'
                    def output = bat(script: 'docker run -d --name python-container imagepython tail -f /dev/null', returnStdout: true).trim()
                    CONTAINER_ID = output.split('\n')[-1].trim()
                    echo "Conteneur lancé avec l'ID : ${CONTAINER_ID}"
                }
            }
        }
}
