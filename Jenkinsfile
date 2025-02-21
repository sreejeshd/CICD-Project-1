pipeline {
    agent any

    environment {
        GITHUB_TOKEN = credentials('CICD-project1')
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    sh '''
                    git clone https://$GITHUB_TOKEN@github.com/sreejeshd/CICD-Project-1.git
                    cd CICD-Project-1
                    '''
                }
            }
        }
        
        stage('Install Puppet Agent') {
            steps {
                script {
                    sh '''
                    sudo apt-get update
                    sudo apt-get install -y puppet
                    sudo /usr/bin/puppet resource service puppet ensure=running enable=true
                    '''
                }
            }
        }

        stage('Install Docker with Ansible') {
            steps {
                script {
                    sh '''
                    ansible-playbook -i inventory install_docker.yml
                    '''
                }
            }
        }

        stage('Deploy PHP Docker Container') {
            steps {
                script {
                    sh '''
                    docker build -t php-app .
                    docker stop php-app-container || true
                    docker rm php-app-container || true
                    docker run -d -p 8081:80 --name php-app-container php-app
                    '''
                }
            }
        }
    }

    post {
        failure {
            script {
                sh '''
                docker rm -f php-app-container || true
                '''
            }
        }
    }
}

