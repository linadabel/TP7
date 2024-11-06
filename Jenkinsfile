pipeline {
    agent any

    environment {
        CONTAINER_ID = ""
        SUM_PY_PATH = "./sum.py"
        DIR_PATH = "./"
        TEST_FILE_PATH = "./test_variables.txt"
        IMAGE_NAME = "votre_nom_docker/sum_image"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Construire l'image Docker
                    docker.build("${IMAGE_NAME}", "${DIR_PATH}")
                    echo "Image Docker construite avec succès : ${IMAGE_NAME}"
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    // Exécuter le conteneur et sauvegarder son ID
                    def output = sh(script: "docker run -d ${IMAGE_NAME} sleep infinity", returnStdout: true).trim()
                    CONTAINER_ID = output
                    echo "Conteneur lancé avec ID : ${CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Lire les lignes du fichier de test et les exécuter dans le conteneur
                    def testLines = readFile("${TEST_FILE_PATH}").split('\n')
                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        // Exécuter sum.py dans le conteneur et récupérer le résultat
                        def output = sh(script: "docker exec ${CONTAINER_ID} python3 /app/sum.py ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.toFloat()

                        // Vérification du résultat
                        if (result == expectedSum) {
                            echo "Test réussi pour ${arg1} + ${arg2} = ${expectedSum}"
                        } else {
                            error "Échec du test pour ${arg1} + ${arg2}. Attendu : ${expectedSum}, mais obtenu : ${result}"
                        }
                    }
                }
            }
        }

        stage('Deploy to DockerHub') {
            steps {
                script {
                    // Connexion à DockerHub
                    sh "docker login -u votre_nom_utilisateur -p votre_mot_de_passe"
                    // Taguer l'image
                    sh "docker tag ${IMAGE_NAME} votre_nom_docker/sum_image:latest"
                    // Pousser l'image vers DockerHub
                    sh "docker push votre_nom_docker/sum_image:latest"
                    echo "Image déployée sur DockerHub"
                }
            }
        }
    }

    post {
        always {
            script {
                // Arrêter et supprimer le conteneur, quelle que soit l'issue
                sh "docker stop ${CONTAINER_ID}"
                sh "docker rm ${CONTAINER_ID}"
                echo "Conteneur arrêté et supprimé."
            }
        }
    }
}
