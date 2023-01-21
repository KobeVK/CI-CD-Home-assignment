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

		stage('starting-fresh') {
            steps {
                script {
                    deleteDir()
                    checkout scm
                }
            }
        }

		stage('Properties Set-up') {
			steps {
				script {
					properties([
						disableConcurrentBuilds()
					])
				}
			}
		}

		stage('prepare') {
			steps {
                withAWS(credentials: 'aws-access-key') {
					script {
						if (branch == 'main') {
							terraform workspace select prod
							env.ENVIRONMENT = 'production'
						} else {
							terraform workspace select dev
							env.ENVIRONMENT = 'staging'	
						}
						sh """
							echo "Starting Terraform init"
							terraform init
							terraform plan -out myplan
							terraform apply -auto-approve
						"""
						_IP = sh(
                        script: "terraform output -raw public_ip",
                        returnStdout: true,
					}
				}
			}
		}

		stage('build and push') {	
			steps {
				sh """
					echo "Hello, World!"
				"""
			}
		}

		stage('Deploy') {
			steps {
				sh """
					echo "kk"
				"""
				// sh "terraform apply -var 'environment=${evni}' -var 'tag_name=${env.GIT_BRANCH}'"
			}
		}

	}
}
