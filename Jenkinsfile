#!groovy


pipeline {
	agent any

	environment {
      branch = "${env.GIT_BRANCH}"
      evni = "${env.ENVIRONMENT}"
	}

	options {
		timestamps()
		// lock(evni)
	}

	stages {
		stage('plan') {
			steps {
				script {
					if (branch == 'main') {
						env.ENVIRONMENT = 'production'
					} else {
						env.ENVIRONMENT = 'staging'
					}
					BUILD_USER_ID = sh (
						script: 'whoami',
						returnStdout: true
					).trim()
					GROUP_FOR_USER = sh (
						script: 'whoami',
						returnStdout: true
					).trim()
					echo "bUILD USER: ${GROUP_FOR_USER }"
					// sh """
					// 	echo "Starting Terraform init"
					// 	./terraform init
					// 	./terraform plan -out myplan
					// """

				}
			}
		}

		stage('Test') {	
			steps {
				sh """
					echo "Hello, World!"
				"""
			}
		}

		stage('Deploy') {
			steps {
				sh "terraform apply -var 'environment=${evni}' -var 'tag_name=${env.GIT_BRANCH}'"
			}
		}

	}
}
