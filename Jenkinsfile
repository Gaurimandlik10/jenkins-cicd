pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        AWS_DEFAULT_REGION    = 'ap-southeast-2'
    }

    stages {
        stage('Git Checkout') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main',
                    url: 'https://github.com/YOUR_USERNAME/devops-project.git'
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initialising Terraform...'
                sh 'cd terraform && terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Planning Terraform...'
                sh 'cd terraform && terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Creating EC2 with Terraform...'
                sh 'cd terraform && terraform apply -auto-approve'
            }
        }

        stage('Get EC2 IP') {
            steps {
                echo 'Getting EC2 IP...'
                script {
                    EC2_IP = sh(
                        script: 'cd terraform && terraform output -raw ec2_public_ip',
                        returnStdout: true
                    ).trim()
                    echo "EC2 IP: ${EC2_IP}"
                }
            }
        }

        stage('Wait for EC2') {
            steps {
                echo 'Waiting for EC2 to be ready...'
                sh 'sleep 30'
            }
        }

        stage('Ansible Deploy') {
            steps {
                echo 'Configuring EC2 with Ansible...'
                sh 'cd ansible && ansible-playbook -i inventory.ini playbook.yml'
            }
        }

        stage('Verify') {
            steps {
                echo 'Verifying deployment...'
                script {
                    sh "curl http://${EC2_IP}"
                }
            }
        }
    }

    post {
        success {
            echo '🎉 Pipeline Successful!'
            echo "Website live at: http://${EC2_IP}"
        }
        failure {
            echo '❌ Pipeline Failed!'
        }
        always {
            echo 'Pipeline finished!'
        }
    }
}