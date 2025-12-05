pipeline {
    agent { label 'wsl' }

    environment {
        AWS_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git(
                    branch: 'main',
                    url: 'https://github.com/gova4all/EC2.git',
                    credentialsId: 'gova_jenkins'
                )
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SonarQube_Creds', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('MySonarServer') {
                        sh '''
                            export PATH=$PATH:/opt/sonar-scanner/bin
                            
                            sonar-scanner \
                                -Dsonar.projectKey=EC2 \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=http://localhost:9000 \
                                -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
    steps {
        echo "Quality Gate check skipped."
    }
}

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'AWS_CREDS']]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=${AWS_REGION}

                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'AWS_CREDS']]) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=${AWS_REGION}

                        terraform plan -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            when { expression { return params.APPLY == true } }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'AWS_CREDS']]) {
                    sh '''
                        terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Approval for Destroy') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: "Do you want to destroy the Terraform infrastructure?"
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'AWS_CREDS']]) {
                    sh '''
                        terraform destroy -auto-approve
                    '''
                }
            }
        }
    }

    post {
        always {
            deleteDir()
        }
    }
}
