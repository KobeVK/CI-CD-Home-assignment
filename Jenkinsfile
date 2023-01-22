#!groovy


pipeline {
	agent any

	environment {
      branch = "${env.GIT_BRANCH}"
      evni = "${env.ENVIRONMENT}"
	  GIT_SSH_COMMAND = "ssh -o StrictHostKeyChecking=no"
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
					cleanWs()
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

		
		stage('Verify') {	
			steps {
				withCredentials([sshUserPrivateKey(credentialsId: "aws", keyFileVariable: 'KEY')]) {
					script{
						IP = sh (
							script: """
								terraform output -raw web_app_access_ip
							""", returnStdout: true
						).trim()
						println "the machine terraform created is  = " + IP
						println "the workspace you're on is  = ${WORKSPACE}"  
						sh """
							sudo -- sh -c "sed 's/.*ssh-rsa/${IP} ssh-rsa/' /home/ubuntu/.ssh/known_hosts"
							sudo -- sh -c "echo ${IP} | sudo tee -a /home/ubuntu/Versatile/hosts"
							sleep 60 
							ansible ${IP} -m ping --private-key=$KEY
						"""
					}
				}
			}
		}
		
		stage('install') {	
			steps {
				withCredentials([sshUserPrivateKey(credentialsId: "aws", keyFileVariable: 'KEY')]) {
					script{
						IP = sh (
							script: """
								terraform output -raw web_app_access_ip
							""", returnStdout: true
						).trim()
						println "the machine terraform created is  = " + IP
						sh """
							sed -i 's/hosts: all/hosts: ${IP}/' deploy_app_playbook.yml
							ansible-playbook deploy_app_playbook.yml
							echo "your deployed web-app can be access here -> http://${IP}:8000"
						"""
					}
				}
			}
		}

		stage('test') {
			steps {
				health_check.sh ${IP}
			}
		}

		stage('Release') {
			steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
					sh """
						docker login  -u ${USERNAME} -p ${PASSWORD}
						docker commit -m "building web-app" versatile versatile_web_app:v1
						docker tag versatile_app sapkobisap/versatile:v1
						docker push sapkobisap/versatile:v1
					"""

				}
			}
		}

		stage('destroy image') {
			steps {
				sh """
					echo "destroying inventory"
				"""
			}
		}

	}
}
