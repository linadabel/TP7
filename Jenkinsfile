pipeline {
    agent any
    environment {
        SUM_PY_PATH = '/app/sum.py'        // Chemin correct dans le conteneur
        DIR_PATH = '.' 
        TEST_FILE_PATH = 'test_variables.txt'
        CONTAINER_NAME = 'python-container'
        IMAGE_NAME = 'imagepython'
        DOCKER_USERNAME = 'lina2607'       // Docker Hub username
        DOCKER_PASSWORD = 'DABEL2607'      // Docker Hub password
    }
    stages {
        stage('Build') {
            steps {
                script {
                    echo "Construction de l'image Docker"
                    def buildResult = bat(script: "docker build -t ${IMAGE_NAME} ${DIR_PATH}", returnStdout: true, returnStatus: true)
                    echo "Build result: ${buildResult}"
                    if (buildResult != 0) {
                        error "Le build Docker a échoué avec le code de sortie ${buildResult}"
                    }
                }
            }
        }
    }
}
