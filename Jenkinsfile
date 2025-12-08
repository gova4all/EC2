pipeline {
    agent { label 'wsl-agent' }
	
    tools {
    git 'WSLGit'
}

    environment {
        // used for terraform/aws etc if needed
        PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/opt/sonar-scanner/bin"
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
                withCredentials([string(credentialsId: 'SonarQube_Creds', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('MySonarServer') {
                        sh '''
                            sonar-scanner \
                      -Dsonar.projectKey=EC2 \
                      -Dsonar.sources=. \
                      -Dsonar.host.url=http://localhost:9000 \
                      -Dsonar.token=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                echo "Skipping Quality Gate stage as per your configuration."
            }
        }

        stage('Terraform Init') {
            steps {
                sh "terraform init"
            }
        }

        stage('Terraform Validate') {
            steps {
                sh "terraform validate"
            }
        }

        stage('Terraform Plan') {
            steps {
                sh "terraform plan -out=tfplan"
            }
        }

        stage('Terraform Apply') {
            steps {
                sh "terraform apply -auto-approve tfplan"
            }
        }

        stage('Approval for Destroy') {
            steps {
                script {
                    input message: 'Do you want to destroy the infrastructure?', ok: 'Yes, Destroy'
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh "terraform destroy -auto-approve"
            }
        }

    }

    post {
        always {
            deleteDir()
        }
    }
}
