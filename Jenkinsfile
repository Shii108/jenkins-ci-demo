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

        stage('Git Info') {
            steps {
                script {
                    env.GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.GIT_BRANCH_NAME = sh(script: "git branch --show-current", returnStdout: true).trim()
                    env.GIT_COMMIT_MSG = sh(script: "git log -1 --pretty=%B", returnStdout: true).trim()
                    env.GIT_AUTHOR = sh(script: "git log -1 --pretty=%an", returnStdout: true).trim()
                    env.GIT_REPO = sh(script: "basename -s .git `git config --get remote.origin.url`", returnStdout: true).trim()
                }
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
            sh '''
            curl -H "Content-Type: application/json" -X POST -d '{
              "embeds": [{
                "title": "✅ Build Succeeded",
                "color": 3066993,
                "fields": [
                  {"name": "Job", "value": "'$JOB_NAME'", "inline": true},
                  {"name": "Build", "value": "#'$BUILD_NUMBER'", "inline": true},
                  {"name": "Version", "value": "'$APP_VERSION'", "inline": true},
                  {"name": "Status", "value": "SUCCESS"},

                  {"name": "👤 Author", "value": "'$GIT_AUTHOR'"},
                  {"name": "📦 Repo", "value": "'$GIT_REPO'"},
                  {"name": "🌿 Branch", "value": "'$GIT_BRANCH_NAME'"},
                  {"name": "🔢 Commit", "value": "'$GIT_COMMIT_SHORT'"},
                  {"name": "📝 Commit Message", "value": "'$GIT_COMMIT_MSG'"}
                ],
                "footer": {
                  "text": "Jenkins CI"
                }
              }]
            }' https://discord.com/api/webhooks/1496207988690653395/Xh0QdeKE3Bw8aKQ2c3AdvJxGi40rrmN1NU07yRZTXaAyhJ1UYlJ-ab49hN2mRnDaXt2L
            '''
        }

        failure {
            sh '''
            curl -H "Content-Type: application/json" -X POST -d '{
              "embeds": [{
                "title": "❌ Build Failed",
                "color": 15158332,
                "fields": [
                  {"name": "Job", "value": "'$JOB_NAME'", "inline": true},
                  {"name": "Build", "value": "#'$BUILD_NUMBER'", "inline": true},
                  {"name": "Version", "value": "'$APP_VERSION'", "inline": true},
                  {"name": "Status", "value": "FAILED"},

                  {"name": "👤 Author", "value": "'$GIT_AUTHOR'"},
                  {"name": "📦 Repo", "value": "'$GIT_REPO'"},
                  {"name": "🌿 Branch", "value": "'$GIT_BRANCH_NAME'"},
                  {"name": "🔢 Commit", "value": "'$GIT_COMMIT_SHORT'"},
                  {"name": "📝 Commit Message", "value": "'$GIT_COMMIT_MSG'"}
                ],
                "footer": {
                  "text": "Jenkins CI"
                }
              }]
            }' https://discord.com/api/webhooks/1496207988690653395/Xh0QdeKE3Bw8aKQ2c3AdvJxGi40rrmN1NU07yRZTXaAyhJ1UYlJ-ab49hN2mRnDaXt2L
            '''
        }
    }
}
