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
						println "the workspace you're on is  = ${WORKSPACE}"  
						sh """
							sudo -- sh -c "sed 's/.*ssh-rsa/${IP} ssh-rsa/' /home/ubuntu/.ssh/known_hosts"
							sudo -- sh -c "echo ${IP} | sudo tee -a /home/ubuntu/Versatile/hosts"
							ansible-playbook -i ${IP} deploy_app_playbook.yml --private-key=$KEY
						"""
					}
				}
			}
		}


		stage('build and tag') {
			steps {
				echo "hi"
				//
				// sh """
				//	foo=$(git show -s --pretty=%an)
				//	docker commit -m "building web-app" -a "Author" container_name new_image:v1
				//"""
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
