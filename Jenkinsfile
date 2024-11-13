pipeline {
    agent any
    environment {
        // Variables d'environnement
        SUM_PY_PATH = 'sum.py'
        DIR_PATH = '.' 
        TEST_FILE_PATH = 'test_variables.txt'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    // Construction de l'image Docker
                    bat "docker build -t imagepython ."
                }
            }
        }
        
        stage('Run') {
            steps {
                script {
                    echo "Running Docker container..."
                    // Lancer le conteneur à partir de l'image construite
                    def output = bat(script: "docker run -d --name pythoncontainer imagepython", returnStdout: true).trim()
                    // Stocker l'ID du conteneur
                    CONTAINER_ID = output
                    echo "Container ID: ${CONTAINER_ID}"
                }
            }
        }
    }
         stage('Test') {
            steps {
                script {
                    echo "Running tests"

                    // Lire le fichier de tests
                    def testLines = readFile(TEST_FILE_PATH).split("\n")
                    
                    // Boucle pour tester chaque ligne
                    testLines.each { line ->
                        def parts = line.split(' ')
                        def arg1 = parts[0]
                        def arg2 = parts[1]
                        def expectedSum = parts[2].toFloat()

                        // Exécution du script sum.py dans le conteneur
                        def output = sh(script: "docker exec ${CONTAINER_ID} python3 /app/sum.py ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.toFloat()

                        // Comparaison avec la somme attendue
                        if (result == expectedSum) {
                            echo "Test passed: ${arg1} + ${arg2} = ${result}"
                        } else {
                            error "Test failed: expected ${expectedSum} but got ${result}"
                        }
                    }
                }
            }
        }

        stage('Post') {
            steps {
                script {
                    // Arrêt et suppression du conteneur
                    echo "Stopping and removing Docker container"
                    bat "docker stop ${CONTAINER_ID}"
                    bat "docker rm ${CONTAINER_ID}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Deploying image to DockerHub"
                    // Connexion à DockerHub
                    bat 'docker login -u lina2607 -p DABEL2607'

                    // Tagging de l'image Docker
                    bat "docker tag sum-python-image lina2607/sum-python-image:latest"

                    // Pousser l'image vers DockerHub
                    bat"docker push lina2607/sum-python-image:latest"
                }
            }
        }
    }

    post {
        always {
            // Nettoyage, suppression du conteneur en cas d'échec ou de succès
            bat "docker stop ${CONTAINER_ID} || true"
            bat "docker rm ${CONTAINER_ID} || true"
        }
    }
}
}
