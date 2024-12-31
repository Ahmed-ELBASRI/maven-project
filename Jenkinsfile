pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'ahmedelbasri/maven-project'
        DOCKER_CREDENTIALS_ID = 'b96862ec-f57f-4f0b-6123-e8ba68563541'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/Ahmed-ELBASRI/maven-project'
            }
        }

        stage('Build and Test') {
            agent {
                docker {
                    image 'maven:3.8-openjdk-17'
                    args '-v /root/.m2:/root/.m2' 
                }
            }
            steps {
                script {
                    sh 'mvn clean install'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    }
                    sh 'docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Deploy Dockerized Project') {
            steps {
                script {
                    sh 'docker pull ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                    sh 'docker stop mycontainer || true'
                    sh 'docker rm mycontainer || true'
                    sh 'docker run -d --name mycontainer ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline finished successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}
