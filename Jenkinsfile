pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('1')
        AWS_SECRET_ACCESS_KEY = credentials('1')
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: '1',
                    url: 'https://github.com/123amit14/Terraform-Jenkins.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_ACCESS_KEY_ID_PSW
                  terraform init
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                  export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_USR
                  export AWS_SECRET_ACCESS_KEY=$AWS_ACCESS_KEY_ID_PSW
                  terraform destroy -auto-approve
                '''
            }
        }
    }
}
