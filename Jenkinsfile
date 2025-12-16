pipeline {
    agent {
        label 'docker-agent'
    }

    environment {
        SONAR_HOST_URL = "http://sonarqube:9000"
    }

    stages {

        stage('Install Tools') {
            steps {
                sh '''
                  apt-get update
                  apt-get install -y unzip curl git

                  # Install Terraform
                  if ! command -v terraform >/dev/null; then
                    curl -fsSL https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip -o terraform.zip
                    unzip terraform.zip
                    mv terraform /usr/local/bin/
                  fi

                  terraform -version
                '''
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/gova4all/EC2.git',
                    credentialsId: 'gova_jenkins'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SonarQube_Creds', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('mysonarqube') {
                        sh '''
                          sonar-scanner \
                            -Dsonar.projectKey=EC2 \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=$SONAR_HOST_URL \
                            -Dsonar.token=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
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
}
