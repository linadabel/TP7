pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = '/app/sum.py'
        DOCKERFILE_PATH = './'
        TEST_FILE_PATH = './test_variables.txt'
        IMAGE_NAME = 'imagepython'
        CONTAINER_NAME = 'sum-container'  // Le nom du conteneur
        DOCKER_USERNAME = 'lina2607'  // Docker Hub username
        DOCKER_PASSWORD = 'DABEL2607'  // Docker Hub password
    }
    stages {
        stage('Build') {
            steps {
                script {
                    echo "Building Docker image..."
                    bat "docker build -t ${IMAGE_NAME} ${DOCKERFILE_PATH}"
                }
            }
        }
        stage('Run') {
            steps {
                script {
                    echo "Removing existing container if it exists..."
                    bat 'docker rm -f sum-container || true'
                    
                    echo "Running Docker container..."
                    def output = bat(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME} tail -f /dev/null", returnStdout: true).trim()
                    CONTAINER_ID = output
                    echo "Container started with ID: ${CONTAINER_ID}"
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

                        echo "Running test: ${arg1} + ${arg2}"
                        def output = bat(script: "docker exec ${CONTAINER_ID} python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.tokenize().last().toFloat()

                        if (result == expectedSum) {
                            echo "Test passed: ${arg1} + ${arg2} = ${expectedSum}"
                        } else {
                            error "Test failed for ${arg1} + ${arg2}. Expected: ${expectedSum}, Got: ${result}"
                        }
                    }
                }
            }
        }
        stage('Performance') {
            steps {
                script {
                    echo "Checking container performance..."
                    def stats = bat(script: "docker stats --no-stream ${CONTAINER_ID}", returnStdout: true).trim()
                    echo "Container ${CONTAINER_ID} stats: \n${stats}"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    echo "Logging into Docker Hub..."
                    bat "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    echo "Tagging and pushing the Docker image to Docker Hub..."
                    bat "docker tag ${IMAGE_NAME} ${DOCKER_USERNAME}/pythonimage:latest"
                    bat "docker push ${DOCKER_USERNAME}/pythonimage:latest"
                }
            }
        }
    }
    post {
        always {
            script {
                if (CONTAINER_ID) {
                    echo "Stopping and removing container ${CONTAINER_ID}..."
                    bat "docker stop ${CONTAINER_ID}"
                    bat "docker rm ${CONTAINER_ID}"
                    echo "Container ${CONTAINER_ID} stopped and removed."
                }
            }
        }
    }
}
