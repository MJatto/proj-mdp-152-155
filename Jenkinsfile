pipeline {
  agent any

  environment {
    IMAGE_NAME = "mjatto/java-webapp-calculator"
    TAG = "${BUILD_NUMBER}"
    CLUSTER_NAMESPACE = "default"
    DEPLOYMENT_NAME = "java-webapp"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'project-3', url: 'https://github.com/MJatto/proj-mdp-152-155.git'
      }
    }

    stage('Build WAR') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME:$TAG .'
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh '''
            echo "$PASS" | docker login -u "$USER" --password-stdin
            docker push $IMAGE_NAME:$TAG
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl set image deployment/$DEPLOYMENT_NAME webapp=$IMAGE_NAME:$TAG --namespace=$CLUSTER_NAMESPACE
        '''
      }
    }
  }
}

