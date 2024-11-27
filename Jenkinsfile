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
              	    //lancer un nouveau conteneur
                    def output = bat(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME} tail -f /dev/null", returnStdout: true).trim()
                    echo "Conteneur lancé avec succès : ${output.split('\n)[-1].trim()}"
                }
            }
        }
       stage('Test') {
            steps {
                script {
                    def testLines = readFile(TEST_FILE_PATH).split('\n')
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
                    bat "docker exec ${CONTAINER_ID} sphinx-build -b html ${SPHINX_SOURCE} ${SPHINX_BUILD_DIR}"

                    archiveArtifacts artifacts: "${SPHINX_BUILD_DIR}/**/*.html", allowEmptyArchive: true
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo "Nettoyage des conteneurs"
                bat "docker rm -f ${CONTAINER_NAME} || true"
                echo "Conteneur ${CONTAINER_NAME} supprimé."
            }
        }
    }
}


