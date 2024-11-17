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
                    def output = bat(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME} tail -f /dev/null", returnStdout: true).trim()
                    echo "Conteneur lancé avec succès : ${output}"
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    echo "Démarrage des tests"
                    try {
                        def testLines = readFile(TEST_FILE_PATH).split('\n')
                        for (line in testLines) {
                            if (line.trim()) { // Ignore les lignes vides
                                def vars = line.split(' ')
                                def arg1 = vars[0]
                                def arg2 = vars[1]
                                def expectedSum = vars[2].toFloat()

                                // Exécute le script Python dans le conteneur Docker
                                def output = bat(script: "docker exec ${CONTAINER_NAME} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                                def result = output.tokenize().last().toFloat()

                                // Vérifie si le résultat est correct
                                if (result == expectedSum) {
                                    echo "Test réussi pour ${arg1} + ${arg2} = ${expectedSum}"
                                } else {
                                    error "Test échoué pour ${arg1} + ${arg2}. Résultat attendu : ${expectedSum}, obtenu : ${result}"
                                }
                            }
                        }
                    } catch (Exception e) {
                        error "Une erreur est survenue pendant les tests : ${e.message}"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    echo "Déploiement de l'image Docker"
                    // Connexion à Docker Hub
                    bat "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    // Tagging de l'image
                    bat "docker tag ${IMAGE_NAME} ${DOCKER_USERNAME}/pythonimage:latest"
                    // Push de l'image vers Docker Hub
                    bat "docker push ${DOCKER_USERNAME}/pythonimage:latest"
                }
            }
        }
    }
    post {
        always {
            script {
                echo "Nettoyage des conteneurs"
                // Supprimer le conteneur Docker après les étapes
                bat "docker rm -f ${CONTAINER_NAME} || true"
                echo "Conteneur ${CONTAINER_NAME} supprimé."
            }
        }
    }
}
