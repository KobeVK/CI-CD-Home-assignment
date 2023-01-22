#!groovy


pipeline {
	agent any
	parameters {
		string(name: 'IP', defaultValue: '')
	}

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
					// abort a running Pipeline build if a new one is started
                    // https://support.cloudbees.com/hc/en-us/articles/360034881371-How-can-I-abort-a-running-Pipeline-build-if-a-new-one-is-started-
                    def buildNumber = env.BUILD_NUMBER as int
                    if (buildNumber > 1) milestone(buildNumber - 1)
                    milestone(buildNumber)
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
						}//maybe add here terraform lock
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
						access_ip = sh (
							script: """
								terraform output -raw web_app_access_ip
							""", returnStdout: true
						).trim()
						env.IP = access_ip
						println "the machine terraform created is  = " + access_ip
						sh """
							sudo -- sh -c "sed 's/.*ssh-rsa/${access_ip} ssh-rsa/' /home/ubuntu/.ssh/known_hosts"
							sudo -- sh -c "echo ${access_ip} | sudo tee -a /home/ubuntu/Versatile/hosts"
							sleep 60 
							ansible ${access_ip} -m ping --private-key=$KEY
						"""
					}
				}
			}
		}
		
		stage('install') {	
			steps {
				withCredentials([sshUserPrivateKey(credentialsId: "aws", keyFileVariable: 'KEY')]) {
					script{
						sh """
							sed -i 's/hosts: all/hosts: ${env.IP}/' deploy_app_playbook.yml
							ansible-playbook deploy_app_playbook.yml
							echo "your deployed web-app can be access here -> http://${env.IP}:8000"
						"""
					}
				}
			}
		}

		stage('test') {
			steps {
				script{
					sh """
                    	bash ./tests/health_check.sh ${env.IP}
                	"""
				}
			}
		}

		stage('Release') {
			steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
					script{
						def buildNumber = env.BUILD_NUMBER
						sh """
							docker login  -u ${USERNAME} -p ${PASSWORD}
							docker commit -m "building web-app" versatile versatile_web_app:${buildNumber}
							docker tag versatile_app sapkobisap/versatile:${buildNumber}
							docker push sapkobisap/versatile:${buildNumber}
						"""
					}
				}
			}
		}

		stage('destroy image') {
			steps {
				when {
					expression {
						env.ENVIRONMENT = 'staging'
					}//maybe add here terraform unlock
				sh """
					terraform apply -destroy
				"""
				}
			}
		}
	}
}
