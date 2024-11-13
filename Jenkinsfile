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
        
        stage('Run') {
            steps {
                script {
                    echo "Running Docker container..."
                    // Lancer le conteneur à partir de l'image construite
                    def output = bat(script: "docker run -d  pythoncontainer imagepython", returnStdout: true).trim()
                    // Stocker l'ID du conteneur
                    CONTAINER_ID = output
                    echo "Container ID: ${CONTAINER_ID}"
                }
            }
        }

      
}
