pipeline {
    agent any
    
    stages {
        stage('Install Puppet Agent') {
            steps {
                script {
                    sh '''
                    # Install and configure Puppet agent on the slave node
                    sudo apt-get update
                    sudo apt-get install -y puppet
                    sudo puppet resource service puppet ensure=running enable=true
                    '''
                }
            }
        }
        
        stage('Install Docker with Ansible') {
            steps {
                script {
                    sh '''
                    # Push Ansible configuration to the test server to install Docker
                    ansible-playbook -i inventory install_docker.yml
                    '''
                }
            }
        }
        
        stage('Deploy PHP Docker Container') {
            steps {
                script {
                    sh '''
                    # Pull the PHP website and Dockerfile from the Git repository, build the Docker image, and deploy the PHP Docker container
                    git clone https://github.com/your-repo/projCert.git
                    cd projCert
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
                # If Job 3 fails, delete the running container on the test server
                docker rm -f php-app-container || true
                '''
            }
        }
    }
}

