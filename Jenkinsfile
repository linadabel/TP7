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

   

        stage('Build') {
            steps {
                script {
                    echo 'Building Docker image...'
                    bat "docker build -t imagepython ${DIR_PATH}"
                }
            }
        }

    