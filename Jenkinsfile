library identifier: "pipeline-library@v1.5",
retriever: modernSCM(
  [
    $class: "GitSCMSource",
    remote: "https://github.com/redhat-cop/pipeline-library.git" 
  ]
)

appName1 = "backend-docker-bc"
appName2 = "frontend-docker-bc"

pipeline {
    agent any
    stages {
//         stage("Checkout") {
//             steps {
//                 checkout scm
//             }
//         }
        stage("Docker Build backend") {
            steps {
                binaryBuild(buildConfigName: appName1, buildFromPath: ".")
            }
        }
      
       stage("Tag backend image") {
       steps{
    tagImage([
            sourceImagePath: "amisha-jenkins",
            sourceImageName: "node-backend",
            sourceImageTag : "latest",
            toImagePath: "amisha-jenkins",
            toImageName    : "node-backend",
            toImageTag     : "${env.BUILD_NUMBER}"
      
    ])
       }
}
     stage("Docker Build frontend") {
            steps {
                binaryBuild(buildConfigName: appName2, buildFromPath: "./client")
            }
        }
      stage("Tag image") {
       steps{
    tagImage([
            sourceImagePath: "amisha-jenkins",
            sourceImageName: "node-frontend",
            sourceImageTag : "latest",
            toImagePath: "amisha-jenkins",
            toImageName    : "node-frontend",
            toImageTag     : "${env.BUILD_NUMBER}"
      
    ])
       }
}
      
       stage("Trigger Deployment Pipeline"){
        steps{
          build job:'docker-pipeline' , parameters: [string(name: 'TAG',value: env.BUILD_NUMBER)]
        }
      }
    }
}
