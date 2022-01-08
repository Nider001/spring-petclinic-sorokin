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
		stage("Build") {
			agent { docker 'maven:3.8.2-jdk-8' }
			steps {
				echo 'Hello, Maven'
				sh 'mvn -B clean package'
				stash includes: 'target/spring-petclinic-2.5.0-SNAPSHOT.jar', name: 'app'
			}
		}
		stage("Wrap and send") {
			agent { docker 'openjdk:8-jre' }
			stages {
				stage("Wrap") {
					steps {
						echo 'Begin wrapping'
						unstash 'app'
						script {
							dockerImage = docker.build registry + ":$BUILD_NUMBER"
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
						sh "docker rmi $registry:$BUILD_NUMBER"
					}
				}
			}
		}
		stage('Run') {
			agent { docker '$registry:$BUILD_NUMBER' }
			steps {
				echo 'Hello, JDK'
				sh 'java -jar ./target/spring-petclinic-2.5.0-SNAPSHOT.jar --server.port=8081'
			}
		}
	}
}