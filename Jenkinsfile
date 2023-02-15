library identifier: "pipeline-library@v1.5",
retriever: modernSCM(
  [
    $class: "GitSCMSource",
    remote: "https://github.com/redhat-cop/pipeline-library.git" 
  ]
)

def backendBuild = true
def frontendBuild = true

pipeline {
    agent any
    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }
        stage("Check for changes") {
            steps {
                script {
                    backendBuild = false
                    frontendBuild = false

                    def changeset = scm.changeset
                    if (changeset != null) {
                        changeset.forEach { commit ->
                            commit.affectedFiles.each { file ->
                                if (file.path.startsWith("client/")) {
                                    frontendBuild = true
                                } else if (file.path in ["Dockerfile", "package-lock.json", "package.json", "server.js"]) {
                                    backendBuild = true
                                }
                            }
                        }
                    }
                }
            }
        }
        stage("Build and tag backend") {
            when {
                expression { backendBuild }
            }
            steps {
                script {
                    def appName = "amisha-expense-tracker-backend-buildconfig"
                    binaryBuild(buildConfigName: appName, buildFromPath: ".")
                    tagImage([
                        sourceImagePath: "amisha-jenkins",
                        sourceImageName: "expense-tracker-backend",
                        sourceImageTag : "latest",
                        toImagePath: "amisha-jenkins",
                        toImageName    : "expense-tracker-backend",
                        toImageTag     : "${env.BUILD_NUMBER}"
                    ])
                }
            }
        }
        stage("Build and tag frontend") {
            when {
                expression { frontendBuild }
            }
            steps {
                script {
                    def appName = "amisha-expense-tracker-frontend-buildconfig"
                    binaryBuild(buildConfigName: appName, buildFromPath: "./client")
                    tagImage([
                        sourceImagePath: "amisha-jenkins",
                        sourceImageName: "expense-tracker-frontend",
                        sourceImageTag : "latest",
                        toImagePath: "amisha-jenkins",
                        toImageName    : "expense-tracker-frontend",
                        toImageTag     : "${env.BUILD_NUMBER}"
                    ])
                }
            }
        }
        stage("Trigger Deployment Pipeline"){
            steps{
                build job:'docker-pipeline' , parameters: [string(name: 'TAG',value: env.BUILD_NUMBER)]
            }
        }
    }
}
