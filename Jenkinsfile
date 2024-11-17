pipeline {
    agent any
    environment {
        // Variables d'environnement
        SUM_PY_PATH = '/app/sum.py' // Chemin correct à l'intérieur du conteneur
        DIR_PATH = '.' 
        TEST_FILE_PATH = 'test_variables.txt'
        CONTAINER_NAME = 'python-container'
        IMAGE_NAME = 'imagepython'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    echo "Construction de l'image Docker"
                    // Construction de l'image Docker
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
                    // Lancer un nouveau conteneur et sauvegarder son ID
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
                    // Lecture des lignes de test
                    def testLines = readFile(TEST_FILE_PATH).split('\n')
                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        // Exécution du script Python dans le conteneur
                        def output = bat(script: "docker exec ${CONTAINER_NAME} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.tokenize().last().toFloat() 
                        
                        // Vérification du résultat
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
   
}
