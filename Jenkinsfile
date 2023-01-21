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

		stage('deploy') {
			steps {
                withAWS(credentials: 'aws-access-key') {
					script {
						if (branch == 'main') {
							// terraform workspace select prod
							env.ENVIRONMENT = 'production'
						} else {
							// terraform workspace select dev
							env.ENVIRONMENT = 'staging'	
						}
						sh """
							echo "Starting Terraform init"
							terraform init
							terraform plan -out myplan
							terraform apply -auto-approve
						"""
					}
				}
			}
		}

		//replace ansible -m ping with ansible-playbook
		withCredentials([sshUserPrivateKey(credentialsId: "aws", keyFileVariable: 'KEY')]) {
			stage('install') {	
				steps {
					script{
						IP = sh (
							script: """
								terraform output -raw web_app_access_ip
							""", returnStdout: true
						).trim()
						println "the machine terraform created is  = " + IP
						sh """
							sudo -- sh -c "sed 's/.*ssh-rsa/${IP} ssh-rsa/' /home/ubuntu/.ssh/known_hosts"
							sudo -- sh -c "echo ${IP} | sudo tee -a /home/ubuntu/Versatile/hosts"
							ansible ${IP} -m ping --private-key=$KEY
						"""
					}
				}
			}
		}

		stage('verify') {	
			steps {
				sh """
					echo "Verifying site is up............."
				"""
			}
		}

		stage('build and tag') {
			steps {
				sh """
					echo "kk"
				"""
				// sh "terraform apply -var 'environment=${evni}' -var 'tag_name=${env.GIT_BRANCH}'"
			}
		}

		stage('destroy image') {
			steps {
				sh """
					echo "destroying inventory"
				"""
				// sh "terraform apply -var 'environment=${evni}' -var 'tag_name=${env.GIT_BRANCH}'"
			}
		}

	}
}
