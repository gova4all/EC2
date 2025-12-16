pipeline {
    agent {
        label 'docker-agent'
    }

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    environment {
        SONAR_HOST_URL = 'http://sonarqube:9000'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/gova4all/EC2.git',
                    credentialsId: 'gova_jenkins'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('mysonarqube') {
                    sh
