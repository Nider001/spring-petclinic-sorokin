pipeline {
	environment {
		registry = "nider001/docker-petclinic"
		registryCredential = 'dockerhub'
		dockerImage = ''
	}
	agent none
	stages {
		stage('Checkout') {
			agent any
			steps {
				cleanWs()
			}
		}
		stage('Build') {
			agent { docker 'maven:3.8.2-jdk-8' }
			steps {
				echo 'Hello, Maven'
				sh 'mvn -B clean package'
				stash includes: 'target/spring-petclinic-2.5.0-SNAPSHOT.jar', name: 'app'
			}
		}
		stage('Wrap') {
			agent { docker 'maven:3.8.2-jdk-8' }
			steps {
				unstash 'app'
				script {
					dockerImage = docker.build registry + ":$BUILD_NUMBER"
				}
				script {
					docker.withRegistry( '', registryCredential ) {
						dockerImage.push()
					}
				}
				sh "docker rmi $registry:$BUILD_NUMBER"
			}			
		}
		stage('Run') {
			agent { docker '$registry/image:latest' }
			steps {
				sh 'java -jar ./target/spring-petclinic-2.5.0-SNAPSHOT.jar --server.port=8081'
			}
		}
	}
}
