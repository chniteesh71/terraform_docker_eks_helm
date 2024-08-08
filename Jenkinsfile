pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'us-east-1'
        registryCredentials = 'dockerhubcreds'
        registry = 'chniteesh71/eksdeploy'
    }
    
    stages {        
        stage ('Build Docker app image') {
          steps {
            script {
              dockerImage = docker.build( registry + ":V$BUILD_NUMBER" , ".")
            }

          }
        }
        

        stage ('upload image to docker hub') {
          steps {
            script {
              docker.withRegistry('',registryCredentials) {
                dockerImage.push("V$BUILD_NUMBER")
                dockerImage.push('latest')

              }
            }
          }
        }

        stage('remove the unused docker images') {
          steps {
            sh "docker rmi $registry:V$BUILD_NUMBER"
          }
        }
        
        stage('Deploy to EKS') {
            agent { label 'EKS'}
            steps {
                withAWS(credentials: 'awscreds', region: "${env.AWS_DEFAULT_REGION}") {
                        script {
                            sh """
                            aws eks update-kubeconfig --name Niteesh-cluster
                            sh "helm upgrade --install --force sample-stack helm/niteeshcharts --set appimage=${registry}:V${BUILD_NUMBER} --namespace prod"
                            """
                        }
                    }
                }
         }
     }
}

