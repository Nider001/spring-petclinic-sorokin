pipeline {
	environment {
		registry = "nider001/docker-petclinic"
		registryCredential = 'dockerhub'
		dockerImageName = ''
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
					dockerImageName = registry + ":petclinic-" + UUID.randomUUID().toString()
					dockerImage = docker.build dockerImageName
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
				sh "docker rmi $dockerImageName"
			}
		}
		stage('Run') {
			agent {
				docker {
					image "$dockerImageName"
					args "-p 127.0.0.1:8000:8080 -d"
				}
			}
			steps {
				echo 'Hello, JDK'
				sh 'java -jar ./target/spring-petclinic-2.5.0-SNAPSHOT.jar'
			}
		}
	}
}