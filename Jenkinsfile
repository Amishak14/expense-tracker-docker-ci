library identifier: "pipeline-library@v1.5",
retriever: modernSCM(
  [
    $class: "GitSCMSource",
    remote: "https://github.com/redhat-cop/pipeline-library.git" 
  ]
)

appName1 = "amisha-expense-tracker-backend-buildconfig"
appName2 = "amisha-expense-tracker-frontend-buildconfig"

pipeline {
    agent any
    stages {
//         stage("Checkout") {
//             steps {
//                 checkout scm
//             }
//         }
        stage("Docker Build and tag backend") {
           when {
        changeset "my-poc/Dockerfile"
        changeset "my-poc/package-lock.json"
        changeset "my-poc/package.json"
        changeset "my-poc/server.js"          
      }
            steps {
                binaryBuild(buildConfigName: appName1, buildFromPath: ".")
            }
          
          tagImage([
           sourceImagePath: "amisha-jenkins",
             sourceImageName: "expense-tracker-backend",
             sourceImageTag : "latest",
            toImagePath: "amisha-jenkins",
            toImageName    : "expense-tracker-backend",
            toImageTag     : "${env.BUILD_NUMBER}"
      
    ])
          
          
        }
      
//        stage("Tag backend image") {
//        steps{
//     tagImage([
//            sourceImagePath: "amisha-jenkins",
//              sourceImageName: "expense-tracker-backend",
//              sourceImageTag : "latest",
//             toImagePath: "amisha-jenkins",
//             toImageName    : "expense-tracker-backend",
//             toImageTag     : "${env.BUILD_NUMBER}"
      
//     ])
//        }
// }
     stage("Docker Build frontend") {
       when {
        changeset "my-poc/client"        
      }
            steps {
                binaryBuild(buildConfigName: appName2, buildFromPath: "./client")
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
//       stage("Tag image") {
//        steps{
//     tagImage([
//              sourceImagePath: "docker.io/amishark",
//              sourceImageName: "expense-tracker-frontend",
//             sourceImageTag : "latest",
//             toImagePath: "docker.io/amishark",
//             toImageName    : "expense-tracker-frontend",
//             toImageTag     : "${env.BUILD_NUMBER}"
      
//     ])
//        }
// }
      
       stage("Trigger Deployment Pipeline"){
        steps{
          build job:'docker-pipeline' , parameters: [string(name: 'TAG',value: env.BUILD_NUMBER)]
        }
      }
    }
}
