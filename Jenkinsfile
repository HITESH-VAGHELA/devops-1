pipeline {
    agent {
        label 'Project1-Babycare'
    }
    stages{
        stage('Build Initiated'){
            steps{
                slackSend channel: 'devops-projects', message: "Build Initiated '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})", tokenCredentialId: 'Slack-Token'
            }
        }
        stage('Code-Checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: 'develop']], extensions: [], userRemoteConfigs: [[credentialsId: 'PAT_Proj1', url: 'http://gitlab.zymrinc.com/ZDevOps/devops-proj-1']]])
            }
        }
        stage('Env-File'){
            steps{
                dir("${env.WORKSPACE}/scripts"){
                sh '''cat > .env << EOL
                    MYSQL_PASSWORD=${MYSQL_PASSWORD}
                    DATABASE=${DATABASE}
                    MYSQL_USER=${MYSQL_USER}
                    DATABASE_SERVER=${DATABASE_SERVER}
                    DATABASE_PORT=${DATABASE_PORT}
                    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
                    RELEASE_TAG=${RELEASE_TAG}'''
                }
            }
        }
        stage('App-Down'){
            steps{
                dir("${env.WORKSPACE}/scripts") {
                sh ''' docker-compose down -v'''
                echo 'Application down successfully'
                } 
            }
        }
        stage('Build-Images'){
            steps{
                dir("${env.WORKSPACE}/scripts"){
                sh ''' sudo docker-compose build --no-cache '''
                echo 'Images Build Successfully'
                }
            }
        }
        stage('Deploy To Dev'){
            steps{
                dir("${env.WORKSPACE}/scripts"){
                sh ''' sudo docker-compose up -d '''
                echo 'Containers Up Successfully'
                }
            }
        }
        stage('Publishing Images to Nexus Repo'){
            steps{
                   sh 'docker tag babycare-backend nexus.zymrinc.com:8083/devops-proj1/babycare-backend'
                   sh 'docker tag babycare-backend nexus.zymrinc.com:8083/devops-proj1/babycare-backend:${RELEASE_TAG}'
                   sh 'docker tag babycare:latest nexus.zymrinc.com:8083/devops-proj1/babycare:latest'
                   sh 'docker tag babycare:latest nexus.zymrinc.com:8083/devops-proj1/babycare:${RELEASE_TAG}'
                withCredentials([usernamePassword(credentialsId: 'Nexus-Cred', passwordVariable: 'password', usernameVariable: 'username')]) {
                   sh 'docker login nexus.zymrinc.com:8083 -u $username -p $password'
                   sh 'docker push nexus.zymrinc.com:8083/devops-proj1/babycare-backend:latest'
                   sh 'docker push nexus.zymrinc.com:8083/devops-proj1/babycare:latest'
                   sh 'docker push nexus.zymrinc.com:8083/devops-proj1/babycare-backend:${RELEASE_TAG}'
                   sh 'docker push nexus.zymrinc.com:8083/devops-proj1/babycare:${RELEASE_TAG}'
                   echo 'Artifacts Published to Nexus Repository.'
                }
            }
        }
        stage("Deploying on Kubernetes Cluster"){
            steps{
                dir("${env.WORKSPACE}/kubernetes"){
                    sh "kubectl apply -f persistent-volume.yaml"
                    sh "kubectl apply -f configmap.yaml"
                    sh "sed 's/RELEASE_TAG/${params.RELEASE_TAG}/g' backend-deployment.yaml | kubectl apply -f -"
                    sh "sed 's/RELEASE_TAG/${params.RELEASE_TAG}/g' frontend-deployment.yaml | kubectl apply -f -"
                    echo "Application deployed successfully on k8's cluster!!"
                }
            }
        }
    }
    post{
            always {
                sh 'docker logout'
            }
            success {
                slackSend channel: 'devops-projects', message: "Build Success '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})", tokenCredentialId: 'Slack-Token'
                emailext attachLog: true, body: 'This job run successfully!!!', subject: 'Jenkins Param Job Status ~ Success', to: 'neraf63162@ekbasia.com'
            }
            unsuccessful {
                slackSend channel: 'devops-projects', failOnError:true, message: "Build Fail '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})", tokenCredentialId: 'Slack-Token' 
                emailext attachLog: true, body: 'This job is fail!!!', subject: 'Jenkins Param Job Status ~ Fail', to: 'neraf63162@ekbasia.com'        
                }
        }
}