pipeline {
    agent any
    environment {
        DOCKERHUB_USER = 'inddocker786'
        IMAGE_NAME = "${DOCKERHUB_USER}/softools-fe"
    }
    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Install & Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} -t ${IMAGE_NAME}:latest ."
                }
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                sh '''
                  kubectl apply -f k8s/namespace.yaml || true
                  kubectl apply -f k8s/mysql.yaml
                  kubectl apply -f k8s/backend.yaml
                  kubectl apply -f k8s/frontend.yaml
                  kubectl rollout restart deployment softoolshop-deployment -n softools
                  kubectl rollout restart deployment softools-fe-deployment -n softools
                '''
            }
        }
    }
}
