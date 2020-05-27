pipeline {
	environment {
		registry = "snikhil1998/covid19-visualization"
		registryCredential = 'dockerhub'
		dockerImage = ''
		buildNumber = "1.0"
	}
	agent any
	stages {
		stage('Build') {
			steps {
				sh "npm build"
			}
		}

		stage('Test') {
			steps {
				sh 'PATH=/home/nikhil/covid19-visualization:$PATH selenium-side-runner Test1.side Test2.side -c "browserName=firefox moz:firefoxOptions.args=[-headless]" --output-directory=results --output-format=junit'
			}
		}

		stage('DockerHub') {
			stages{
				stage('Build Image') {
					steps{
						script {
							dockerImage = docker.build registry + ":" + buildNumber
						}
					}
				}
				stage('Push Image') {
					steps{
						script {
							docker.withRegistry( '', registryCredential ) {
								dockerImage.push()
								tagLatest = "docker tag " + registry  + ":" + buildNumber + " " + registry + ":latest"
								sh tagLatest
								pushLatestBuild = "docker push " + registry
								sh pushLatestBuild
							}
						}
					}
				}
			}
		}
		stage('Deploy') {
			agent any
			steps {
				script {
					step([$class: "RundeckNotifier",
					rundeckInstance: "Rundeck",
					options: """
						BUILD_VERSION=1.0
					""",
					jobId: "4b27a63a-b6b1-42a3-8681-d5066dea3c10"])
				}
			}
		}
	}
}
