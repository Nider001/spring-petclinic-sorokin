pipeline {
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
				sh 'mvn -B -D skipTests clean package'
                                stash includes: 'target/spring-petclinic-2.5.0-SNAPSHOT.jar', name: 'app'
			}
		}
		stage('Run') {
			agent { docker 'openjdk:8-jre' }
			steps {
				echo 'Hello, JDK'
                                unstash 'app'
				sh 'java -jar ./target/spring-petclinic-2.5.0-SNAPSHOT.jar'
			}
		}
	}
}
