pipeline {
	environment {
		registry = "nider001/docker-petclinic"
		registryCredential = 'dockerhub'
		dockerImage = ''
	}
	agent any
	stages {
		stage('Init') {
			steps {
				cleanWs()
				git 'https://github.com/Nider001/spring-petclinic-sorokin.git'
			}
		}
		stage("Build") {
			agent { docker 'maven:3.8.2-jdk-8' }
			steps {
				echo 'Hello, Maven'
				sh 'mvn -B clean package'
				stash includes: 'target/spring-petclinic-2.5.0-SNAPSHOT.jar', name: 'app'
			}
		}
		stage("Wrap") {
			steps {
				echo 'Begin wrapping'
				unstash 'app'
				script {
					dockerImage = docker.build registry + ":petclinic-" + UUID.randomUUID().toString()
				}
			}
		}
		stage("Send") {
			steps {
				echo 'Begin sending'
				script {
					docker.withRegistry( '', registryCredential ) {
						dockerImage.push()
					}
				}
			}
		}
		stage('Remove image') {
			steps{
				echo 'Remove image'
				sh "docker rmi $dockerImage"
			}
		}
		stage('Run') {
			agent {
				docker {
					image '$registry:$BUILD_NUMBER'
					args '--network jenkins/jenkins:lts --rm -p 8081:8081'
				}
			}
			steps {
				echo 'Hello, JDK'
				sh 'java -jar -Dserver.port=8081 ./target/spring-petclinic-2.5.0-SNAPSHOT.jar'
			}
		}
	}
}