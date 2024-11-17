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
                        //supprimer le conteneur s'il existe deja
                        bat "docker rm -f ${CONTAINER_NAME} || true" 
                        def output = bat(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME} tail -f /dev/null", returnStdout:
                        echo "Conteneur lancé avec succès : ${output.split('\n'[-1].trim(}"
                  
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
                    
                    }
                }
            }
        
        stage('Deploy') {
            steps {
                script {
         
                        bat "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        bat "docker tag ${IMAGE_NAME} ${DOCKER_USERNAME}/pythonimage:latest"
                        bat "docker push ${DOCKER_USERNAME}/pythonimage:latest"
                    
                    }
                }
            }
        
    
    post {
        always {
            script {
              
             
                    if (CONTAINER_ID) {
                        bat "docker stop ${CONTAINER_ID} || true"
                        bat "docker rm ${CONTAINER_ID} || true"
                        echo "Conteneur ${CONTAINER_ID} arréte et supprimé."
                }
            }
        }
    
}
