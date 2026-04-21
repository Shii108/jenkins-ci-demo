pipeline {
    agent any

    environment {
        APP_VERSION = '1.0.0'
        BUILD_TS = "${new Date().format('dd/MM/yyyy HH:mm:ss')}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'chmod +x app.sh test.sh'
                sh './app.sh'
            }
        }

        stage('Test') {
            steps {
                sh './test.sh'
            }
        }

        stage('Archive Artifacts') {
             when {
                  branch 'main'
               }

            steps {
                archiveArtifacts artifacts: 'app.sh', fingerprint: true
            }
        }
    }

    post {
        success {
            echo 'Build succeeded.'
        }
        failure {
            echo "Build failed. URL: ${env.BUILD_URL}"
        }
        always {
            cleanWs()
        }
    }
}
