pipeline {
    agent any
    environment {
        // Variables d'environnement
        SUM_PY_PATH = 'sum.py'
        DIR_PATH = '.' 
        TEST_FILE_PATH = 'test_variables.txt'
        CONTAINER_NAME = 'python-container'
        IMAGE_NAME = 'imagepython'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    echo "Construction de l'image Docker"
                    // Construction de l'image Docker
                    bat "docker build -t ${IMAGE_NAME} ${DIR_PATH}"
                }
            }
        }
        stage('Run') {
            steps {
                script {
                    echo "Démarrage du conteneur Docker"
                    // Supprimer le conteneur s'il existe déjà
                    bat "docker rm -f ${CONTAINER_NAME} || true"
                    // Lancer un nouveau conteneur
                    def output = bat(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME} tail -f /dev/null", returnStdout: true).trim()
                    echo "Conteneur lancé avec succès : ${output.split('\n')[-1].trim()}"
                }
            }
        }
    }
}
