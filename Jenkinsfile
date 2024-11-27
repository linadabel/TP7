pipeline {
    agent any
    environment {
        SUM_PY_PATH = '/app/sum.py'        // Chemin correct dans le conteneur
        DIR_PATH = '.' 
        TEST_FILE_PATH = 'test_variables.txt'
        CONTAINER_NAME = 'python-container'
        IMAGE_NAME = 'imagepython'
        DOCKER_USERNAME = 'lina2607'       // Docker Hub username
        DOCKER_PASSWORD = 'DABEL2607'
        CONTAINER_ID = '' // Déclarez CONTAINER_ID pour le suivre tout au long du pipeline
        SPHINX_SOURCE = '/app/docs/source' 
        SPHINX_BUILD_DIR = '/app/docs/build' 
    }
    stages {
        stage('Build') {
            steps {
                script {
                    echo "Construction de l'image Docker"
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
                    CONTAINER_ID = output.split('\n')[-1].trim() // Assurez-vous de récupérer l'ID du conteneur
                    echo "Conteneur lancé avec succès avec l'ID : ${CONTAINER_ID}"
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    def testLines = readFile(TEST_FILE_PATH).split('\n').findAll { it } // Ignore les lignes vides
                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = bat(script: "docker exec ${CONTAINER_ID} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.tokenize().last().toFloat() 
                        if (result == expectedSum) {
                            echo "Test réussi pour ${arg1} + ${arg2} = ${expectedSum}"
                        } else {
                            error "Test échoué pour ${arg1} + ${arg2}. Résultat attendu : ${expectedSum}, obtenu : ${result}"
                        }
                    }
                }
            }
        }
        stage('Performance Monitoring') {
            steps {
                script {
                    def stats = bat(script: "docker stats --no-stream ${CONTAINER_ID}", returnStdout: true).trim()
                    echo "Performances du conteneur ${CONTAINER_ID} : \n${stats}"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    echo "Déploiement de l'image Docker"
                    bat "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    bat "docker tag ${IMAGE_NAME} ${DOCKER_USERNAME}/pythonimage:latest"
                    bat "docker push ${DOCKER_USERNAME}/pythonimage:latest"
                }
            }
        }
        stage('Documentation') {
            steps {
                script {
                    // Assurez-vous que les variables SPHINX_SOURCE et SPHINX_BUILD_DIR sont définies ou passées dans l'environnement si nécessaire
                    bat "docker exec ${CONTAINER_ID} sphinx-build -b html ${SPHINX_SOURCE} ${SPHINX_BUILD_DIR}"
                    archiveArtifacts artifacts: "${SPHINX_BUILD_DIR}/**/*.html", allowEmptyArchive: true
                }
            }
        }
    }
    post {
        always {
            script {
                if (CONTAINER_ID) {
                    bat "docker stop ${CONTAINER_ID}"
                    bat "docker rm ${CONTAINER_ID}"
                    echo "Conteneur ${CONTAINER_ID} arrêté et supprimé."
                }
            }
        }
    }
}
