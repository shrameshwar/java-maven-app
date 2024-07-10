pipeline {
    agent any
    tools {
        maven 'maven'
    }
    environment {
        SCANNER_HOME = tool 'SonarQube Scanner'
        DOCKER_CRED = credentials('DOCKER')
    }
    stages {
        stage('gitclone') {
            steps {
                git url: 'https://github.com/shrameshwar/java-maven-app.git', branch: 'main'
            }
        }
        stage('Maven Build') {
            steps {
                echo 'Building the project...'
                sh 'mvn clean package'
            }
        }
        stage('sonarqube-analysis') {
            steps {
                withSonarQubeEnv('sonarQube-server') {
                    sh 'mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=CI \
                        -Dsonar.host.url=http://34.125.125.40:9000 \
                        -Dsonar.login=sqp_1aaaf63b9f4858839c8e318c016456f46f542e42'
                }
            }
        }
        stage('Docker Image Creation') {
            steps {
                // Define steps for the image build
                echo 'Image building...'
                sh 'docker build -t asia-east1-docker.pkg.dev/charged-gravity-425405-j6/docker-image/java-application .'
            }
        }
        stage('Trivy Image Scanning') {
            steps {
                sh 'trivy image asia-east1-docker.pkg.dev/charged-gravity-425405-j6/docker-image/java-application:latest'
            }
        }
        stage('Image pushing to Google Artifact') {
            steps {
                // Define steps for the image push...
                echo 'Image pushing...'
                sh 'gcloud auth configure-docker \
                    asia-east1-docker.pkg.dev'
                sh 'docker push asia-east1-docker.pkg.dev/charged-gravity-425405-j6/docker-image/java-application'
            }
        }
    }
    post {
        success {
            echo 'Pipeline succeeded!'
            mail to: 'shrameshwar1999@gmail.com',
                subject: "Pipeline Succeeded: ${currentBuild.fullDisplayName}",
                body: "The pipeline ${env.BUILD_URL} has successfully completed."
        }
        failure {
            echo 'Pipeline failed!'
            mail to: 'shrameshwar1999@gmail.com',
                subject: "Pipeline Failed: ${currentBuild.fullDisplayName}",
                body: "The pipeline ${env.BUILD_URL} has failed. Check the logs for details."
        }
    }
}
