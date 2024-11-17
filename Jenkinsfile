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
        CONTAINER_ID = ''                  // Initialise CONTAINER_ID
    }
    stages {
        stage('Build') {
            steps {
                script {
                    try {
                        echo "Construction de l'image Docker"
                        // Affiche les logs de Docker en cas d'échec
                        bat "docker build --no-cache -t ${IMAGE_NAME} ${DIR_PATH}"
                    } catch (Exception e) {
                        echo "Erreur lors de la construction de l'image Docker : ${e.message}"
                        // Affiche les logs de Docker pour aider au débogage
                        echo "Logs d'erreur de la construction Docker :"
                        bat "docker build --no-cache -t ${IMAGE_NAME} ${DIR_PATH} || true"
                        error "Échec de la construction de l'image Docker"
                    }
                }
            }
        }
        stage('Run') {
            steps {
                script {
                    try {
                        echo "Démarrage du conteneur Docker"
                        // Supprime le conteneur s'il existe déjà
                        bat "docker rm -f ${CONTAINER_NAME} || true"
                        def output = bat(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME} tail -f /dev/null", returnStdout: true).trim()
                        env.CONTAINER_ID = output.split('\n')[-1].trim()
                        echo "Conteneur lancé avec succès : ${env.CONTAINER_ID}"
                    } catch (Exception e) {
                        error "Erreur lors du démarrage du conteneur : ${e.message}"
                    }
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    try {
                        echo "Démarrage des tests"
                        def testLines = readFile(TEST_FILE_PATH).split('\n')
                        for (line in testLines) {
                            if (line.trim()) { // Ignore les lignes vides
                                def vars = line.split(' ')
                                def arg1 = vars[0]
                                def arg2 = vars[1]
                                def expectedSum = vars[2].toFloat()

                                def output = bat(script: "docker exec ${CONTAINER_NAME} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                                def result = output.tokenize().last().toFloat()
                                
                                if (result == expectedSum) {
                                    echo "Test réussi pour ${arg1} + ${arg2} = ${expectedSum}"
                                } else {
                                    error "Test échoué pour ${arg1} + ${arg2}. Résultat attendu : ${expectedSum}, obtenu : ${result}"
                                }
                            }
                        }
                    } catch (Exception e) {
                        error "Erreur lors de l'exécution des tests : ${e.message}"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    try {
                        echo "Déploiement de l'image Docker sur DockerHub"
                        bat "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        bat "docker tag ${IMAGE_NAME} ${DOCKER_USERNAME}/pythonimage:latest"
                        bat "docker push ${DOCKER_USERNAME}/pythonimage:latest"
                    } catch (Exception e) {
                        error "Erreur lors du déploiement de l'image Docker : ${e.message}"
                    }
                }
            }
        }
        stage('Performance') {
            steps {
                script {
                    try {
                        echo "Collecte des statistiques de performance Docker"
                        
                        // Vérifie si CONTAINER_ID est défini
                        if (env.CONTAINER_ID) {
                            def stats = bat(script: "docker stats --no-stream ${CONTAINER_ID}", returnStdout: true).trim()
                            echo "Docker Stats: ${stats}"
                        } else {
                            echo "Aucun conteneur actif pour collecter des statistiques."
                        }
                    } catch (Exception e) {
                        echo "Erreur lors de la collecte des statistiques de performance : ${e.message}"
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                echo "Nettoyage des ressources Docker"
                try {
                    if (env.CONTAINER_ID) {
                        bat "docker stop ${CONTAINER_ID} || true"
                        bat "docker rm ${CONTAINER_ID} || true"
                    }
                } catch (Exception e) {
                    echo "Erreur lors du nettoyage des ressources Docker : ${e.message}"
                }
            }
        }
        success {
            echo "Pipeline exécuté avec succès."
        }
        failure {
            echo "Pipeline échoué."
        }
    }
}
