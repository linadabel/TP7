pipeline {
    agent any
    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = 'sum.py'  
        DIR_PATH = '.'  
        TEST_FILE_PATH = 'test_variables.txt'  
    }
    stages {
        stage('Build') {
            steps {
                script {
                    // Construction de l'image Docker
                    echo "Construction de l'image Docker"
                    bat "docker build -t imagepython ."
                }
            } 
        }
    }
	stage('Run') {
            steps {
                script {
                    echo "Running Docker container..."
                    // Run the container from the image built
                    def output = bat(script: "docker run -d --name pythoncontainer imagepython", returnStdout: true).trim()
                    
                    // Store the container ID returned by Docker
                    CONTAINER_ID = output
                    echo "Container ID: ${CONTAINER_ID}"
                }
            }
        }
}
 