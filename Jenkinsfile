pipeline {
    agent any

    environment {
        CONTAINER_ID = ""
        SUM_PY_PATH = "sum.py"              // Chemin vers sum.py sur Windows
        DIR_PATH = "."   // Répertoire contenant le Dockerfile
        TEST_FILE_PATH = "test_variables.txt" // Chemin vers test_variables.txt sur Windows
        DOCKER_IMAGE = "imagepython"                       // Nom de l'image Docker
        DOCKER_CONTAINER_NAME = "pythoncontainer"          // Nom du conteneur Docker
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    echo 'Building Docker image...'
                    bat "docker build -t imagepython"
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    echo 'Running Docker container...'
                    def output = bat(script: "docker run -d --name pythoncontainer imagepython", returnStdout: true)
                    def lines = output.split('\n')
                    CONTAINER_ID = lines[-1].trim()
                    echo "Container ID: cce33d6d6c45"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    def testLines = readFile("${TEST_FILE_PATH}").split('\n')

                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = bat(script: "docker exec pythoncontainer python ${SUM_PY_PATH} ${arg1} ${arg2}", returnStdout: true)
                        def result = output.split('\n')[-1].trim().toFloat()

                        if (result == expectedSum) {
                            echo "Test passed: ${arg1} + ${arg2} = ${result}"
                        } else {
                            error "Test failed: expected ${expectedSum}, but got ${result}"
                        }
                    }
                }
            }
        }

        stage('Deploy to DockerHub') {
            steps {
                script {
                    echo 'Deploying Docker image to DockerHub...'
                    bat "docker login -u lina2607 -p DABEL2607"
                    bat "docker tag ${DOCKER_IMAGE} lina2607/imagepython:latest"
                    bat "docker push lina2607/imagepython:latest"
                }
            }
        }
    }

    post {
        always {
            script {
                echo 'Cleaning up Docker container...'
                bat "docker rm -f pythoncontainer || echo Container not found."
            }
        }
    }
}
