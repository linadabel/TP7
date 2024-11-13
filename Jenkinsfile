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
}
 