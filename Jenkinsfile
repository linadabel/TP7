pipeline {
    agent any
    environment {
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
                    echo "Construction de l'image Docker........"
                    bat "docker build -t ${IMAGE_NAME} \"${DIR_PATH}\""
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    echo 'Démarrage du conteneur Docker.........'
                    def output = bat(script: 'docker run -d python-sum tail -f /dev/null', returnStdout: true)
                    CONTAINER_ID = output.trim().split('\r\n')[-1].trim()
                    echo "Conteneur démarré avec l'ID : ${CONTAINER_ID}"
                }
            }
        }

        stage('Test'){
            steps {
                script{
                    echo"Exécution des tests..........."
                    def testLines = readFile("${TEST_FILE_PATH}").split('\n')
                        for (line in testLines) {
                            line = line.trim()
                            if(line && line.split(' ').length == 3) {
                                def vars = line.split(' ')
                                try {
                                    def arg1 = vars[0]
                                    def arg2 = vars[1]
                                    def expectedSum = vars[2].toFloat()

                                    def output = bat(script: "docker exec ${CONTAINER_ID} python /app/sum.py ${arg1} ${arg2}", returnStdout: true)
                                    def result = output.split('\n')[-1].trim().toFloat()

                                    if (result == expectedSum) {
                                        echo "Test réussi pour ${arg1} + ${arg2} = ${expectedSum}"
                                    } else {
                                        error "Échec du test pour ${arg1} + ${arg2}. Résultat attendu : ${expectedSum}, obtenu : ${result}"
                                    }
                                } catch (Exception e){
                                    error "Erreur lors du traitement de la ligne '${line}': ${e.message}"
                                }
                            } else {
                                echo "Ligne ignorée : '${line}' (format incorrect)"
                            }
                        }
                }   
            }
        }

        stage('Déploiement sur DockerHub') {
            steps {
                echo 'Déploiement de limage Docker sur DockerHub...'
                script {
                    bat 'docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} 
                    bat 'docker tag ${IMAGE_NAME} ${DOCKER_USERNAME} /pythonimage:latest'
                    bat 'docker push ${DOCKER_USERNAME}/pythonimage:latest'
                }
            }
        }

        stage('Analyse des performances') {
            steps {
                script {
                    echo 'Analyse des performances du conteneur...'
                    def statsOutput = bat(script: "docker stats ${CONTAINER_ID} --no-stream", returnStdout: true)
                    echo "Consommation des ressources :\n${statsOutput}"
                }
            }
        }
        
        stage('Documentation') {
            steps {
                script {
                    echo 'Génération de la documentation...'

                    bat "docker exec ${CONTAINER_ID} sphinx-build -b html /app/source /app/build"
                    
                    echo "Contenu du répertoire build :"
                    bat "docker exec ${CONTAINER_ID} ls /app/build"

                    bat "docker cp ${CONTAINER_ID}:/app/build ${WORKSPACE}/build"
            
                    // Afficher le contenu du répertoire où les fichiers ont été copiés
                    bat "dir \"${WORKSPACE}\\build\""
                    
                    // Archiver les fichiers copiés
                    // archiveArtifacts "${WORKSPACE}/build//*"
                            
                    archiveArtifacts 'build//*'
                }
            }
        }

    }

    post {
        always {
            script {
                echo 'Arrêt et suppression du conteneur...'
                bat "docker stop ${CONTAINER_ID}"
                bat "docker rm ${CONTAINER_ID}"
            }
        }
    }

}