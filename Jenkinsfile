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
                    // Démarrer un conteneur et récupérer l'ID du conteneur
                    def output = bat(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME} tail -f /dev/null", returnStdout: true).trim()
                    env.CONTAINER_ID = output.split('\n')[-1].trim()
                    echo "Conteneur lancé avec succès : ${env.CONTAINER_ID}"
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    echo "Démarrage des tests"
                    // Lire les tests depuis le fichier et exécuter chaque test
                    def testLines = readFile(TEST_FILE_PATH).split('\n')
                    for (line in testLines) {
                        if (line.trim()) { // Ignore les lignes vides
                            def vars = line.split(' ')
                            def arg1 = vars[0]
                            def arg2 = vars[1]
                            def expectedSum = vars[2].toFloat()

                            // Exécuter le script Python dans le conteneur
                            def output = bat(script: "docker exec ${CONTAINER_NAME} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                            def result = output.tokenize().last().toFloat()
                            
                            // Vérifier si le résultat est correct
                            if (result == expectedSum) {
                                echo "Test réussi pour ${arg1} + ${arg2} = ${expectedSum}"
                            } else {
                                error "Test échoué pour ${arg1} + ${arg2}. Résultat attendu : ${expectedSum}, obtenu : ${result}"
                            }
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    echo "Déploiement de l'image Docker sur DockerHub"
                    // Se connecter à Docker Hub et pousser l'image
                    bat "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    bat "docker tag ${IMAGE_NAME} ${DOCKER_USERNAME}/pythonimage:latest"
                    bat "docker push ${DOCKER_USERNAME}/pythonimage:latest"
                }
            }
        }
    }
    post {
        always {
            script {
                echo "Nettoyage des ressources Docker"
                // Arrêter et supprimer le conteneur Docker à la fin
                if (env.CONTAINER_ID) {
                    bat "docker stop ${CONTAINER_ID} || true"
                    bat "docker rm ${CONTAINER_ID} || true"
                }
            }
        }
    }
}
