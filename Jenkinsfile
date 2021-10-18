pipeline {
	agent none
	stages {
		stage('Build') {
			agent { docker 'maven:3.8.2-jdk-8' }
			steps {
				echo 'Hello, Maven'
				sh 'mvn -B clean package'
			}
		}
		stage('Run') {
			agent { docker 'openjdk:8-jre' }
			steps {
				echo 'Hello, JDK'
				sh 'java -jar /spring-petclinic-2.5.0-SNAPSHOT.jar'
			}
		}
	}
}