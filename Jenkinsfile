pipeline {
    agent {label 'slave-1'}

    environment {
        imagename = "drwizzy/abctechnologies"
        dockerImage = ''
        appName = "abctechnologies"
    }

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "Maven"
    }

    stages {
        stage('Code Checkout'){
            steps{
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/kemsoft/XYZ-Tech.git'
            }
        }

        stage('Compile'){
            steps{
                sh 'mvn compile'
            }
        }

        stage('Test'){
            steps{
                sh 'mvn test'
            }
        }

        stage('Package WAR') {
            steps {
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }

            post {
                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    jacoco()
                    junit '**/target/surefire-reports/TEST-*.xml'
                    archiveArtifacts 'target/*.war'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                
                 sh 'docker build -t abctechnologies .'
                 echo 'Image Build Completed!!'
                 sh "docker tag abctechnologies:latest drwizzy/abctechnologies:$BUILD_TAG"
                 sh "docker images"
            }
        }

        stage('Publish Docker Image') {
            steps {
                echo 'Logging to Docker Hub...'
                script {
                    withDockerRegistry(credentialsId: 'dockerhub', url: '') {
                        docker.image("drwizzy/abctechnologies:$BUILD_TAG").push()
                    }
                }
            }
        }

        stage('Remove Docker Images') {
            steps {
                sh 'docker image rmi $(docker images -a -q) --force'
            }
        }

        stage('Create EKS Deployment and Service') {
            steps {
                sh 'ansible-playbook deployment-playbook.yml'
            } 
        }
    }
}