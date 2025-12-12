pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/123amit14/Terraform-Jenkins'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    sh '''
                        cd terraform
                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                    sh '''
                        cd terraform
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}
