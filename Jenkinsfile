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
                    // Ajout d'une gestion d'erreur avec try-catch
                    try {
                        bat "docker build -t ${IMAGE_NAME} ${DIR_PATH}"
                    } catch (Exception e) {
                        error "Erreur lors de la construction de l'image Docker: ${e.getMessage()}"
                    }
                }
            }
        }
        stage('Run') {
            steps {
                script {
                    echo "Démarrage du conteneur Docker"
                    try {
                        bat "docker rm -f ${CONTAINER_NAME} || true" // Supprimer le conteneur s'il existe déjà
                        def output = bat(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME} tail -f /dev/null", returnStdout: true).trim()
                        env.CONTAINER_ID = output.split('\n')[-1].trim()
                        echo "Conteneur lancé avec succès : ${env.CONTAINER_ID}"
                    } catch (Exception e) {
                        error "Erreur lors du démarrage du conteneur Docker: ${e.getMessage()}"
                    }
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
                        error "Erreur lors des tests : ${e.getMessage()}"
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    echo "Déploiement de l'image Docker sur DockerHub"
                    try {
                        bat "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        bat "docker tag ${IMAGE_NAME} ${DOCKER_USERNAME}/pythonimage:latest"
                        bat "docker push ${DOCKER_USERNAME}/pythonimage:latest"
                    } catch (Exception e) {
                        error "Erreur lors du déploiement de l'image Docker: ${e.getMessage()}"
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
                    echo "Erreur lors du nettoyage des ressources Docker: ${e.getMessage()}"
                }
            }
        }
    }
}
