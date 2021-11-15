pipeline {
	environment {
		registry = "nider001/docker-petclinic"
		registryCredential = 'dockerhub'
		dockerImage = ''
	}
	agent docker 'maven:3.8.2-jdk-8'
	stages {
		stage('Checkout') {
			agent any
			steps {
				cleanWs()
			}
		}
		stage('Build') {
			steps {
				echo 'Hello, Maven'
				sh 'mvn -B clean package'
			}
		}		
		stage('Run') {
			agent { dockerfile true }
			steps {
				echo 'Hello, JRE'
				sh 'java -jar ./target/spring-petclinic-2.5.0-SNAPSHOT.jar --server.port=8081'
			}
		}
	}
}
