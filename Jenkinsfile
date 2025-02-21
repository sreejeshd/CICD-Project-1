pipeline {
    agent { label 'slave-node' }

    environment {
        GITHUB_TOKEN = credentials('CICD-project1')
    }
    
    stages {
        stage('Clone Repository') {
            steps {
                script {
                    sh '''
                    if [ -d "CICD-Project-1" ]; then
                        rm -rf CICD-Project-1
                    fi
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
                    sudo /opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true
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
        success {
            echo 'Build succeeded! Application deployed successfully.'
        }
        failure {
            echo 'Build failed. Performing cleanup...'
            // Remove the Docker container if the build fails
            sh '''
            docker rm -f php-app-container || true
            '''
            }
        }
    }

