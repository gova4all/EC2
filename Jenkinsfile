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
                    sh '''
                      sonar-scanner \
                        -Dsonar.projectKey=EC2 \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=$SONAR_HOST_URL
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Approval for Destroy') {
            steps {
                input message: 'Do you want to destroy the infrastructure?', ok: 'Yes, Destroy'
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully.'
        }
        failure {
            echo '❌ Pipeline failed. Check logs above.'
        }
        aborted {
            echo '⚠️ Pipeline aborted by user or Quality Gate.'
        }
    }
}
