pipeline {
    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')    
    } 

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any

    stages {
        stage('checkout') {
            steps {
                dir("terraform") {
                    git branch: 'main', url: 'https://github.com/123amit14/Terraform-Jenkins.git'
                }
            }
        }

        stage('Plan') {
            steps {
                dir("terraform") {
                    sh 'terraform init'
                    sh 'terraform plan -out tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.action
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                dir("terraform") {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }
}
