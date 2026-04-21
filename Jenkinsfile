pipeline {
    agent any

    environment {
        APP_VERSION = '1.0.0'
        DISCORD_WEBHOOK_URL = 'https://discord.com/api/webhooks/1496207988690653395/Xh0QdeKE3Bw8aKQ2c3AdvJxGi40rrmN1NU07yRZTXaAyhJ1UYlJ-ab49hN2mRnDaXt2L'
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
                    env.BUILD_TS = new Date().format('dd/MM/yyyy HH:mm:ss')

                    env.GIT_COMMIT_SHORT = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()

                    env.GIT_BRANCH_NAME = env.BRANCH_NAME ?: env.GIT_BRANCH ?: sh(
                        script: "git rev-parse --abbrev-ref HEAD",
                        returnStdout: true
                    ).trim()

                    env.GIT_COMMIT_MSG = sh(
                        script: "git log -1 --pretty=%B",
                        returnStdout: true
                    ).trim()

                    env.GIT_AUTHOR = sh(
                        script: "git log -1 --pretty=%an",
                        returnStdout: true
                    ).trim()

                    env.GIT_REPO = sh(
                        script: 'basename -s .git "$(git config --get remote.origin.url)"',
                        returnStdout: true
                    ).trim()
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
                JSON_PAYLOAD=$(jq -n \
                  --arg job "${JOB_NAME:-Unknown}" \
                  --arg build "${BUILD_NUMBER:-0}" \
                  --arg version "${APP_VERSION:-N/A}" \
                  --arg author "${GIT_AUTHOR:-Unknown}" \
                  --arg repo "${GIT_REPO:-Unknown}" \
                  --arg branch "${GIT_BRANCH_NAME:-Unknown}" \
                  --arg commit "${GIT_COMMIT_SHORT:-Unknown}" \
                  --arg msg "${GIT_COMMIT_MSG:-No commit message}" \
                  --arg ts "${BUILD_TS:-Unknown}" \
                  --arg buildUrl "${BUILD_URL:-}" \
                  '{
                    embeds: [{
                      title: "✅ Build Succeeded",
                      color: 3066993,
                      description: (
                        "**Job:** " + $job + "\n" +
                        "**Build:** #" + $build + "\n" +
                        "**Version:** " + $version + "\n" +
                        "**Status:** SUCCESS\n" +
                        "**Time:** " + $ts + "\n\n" +
                        "👤 **Author:** " + $author + "\n" +
                        "📦 **Repo:** " + $repo + "\n" +
                        "🌿 **Branch:** " + $branch + "\n" +
                        "🔢 **Commit:** " + $commit + "\n" +
                        "📝 **Commit_Message:** " + $msg + "\n\n" +
                        "[View Build Logs](" + $buildUrl + ")"
                      ),
                      footer: {
                        text: "Jenkins CI"
                      }
                    }]
                  }')

                curl -sS -X POST \
                  -H "Content-Type: application/json" \
                  -d "$JSON_PAYLOAD" \
                  "$DISCORD_WEBHOOK_URL"
            '''
        }

        failure {
            sh '''
                JSON_PAYLOAD=$(jq -n \
                  --arg job "${JOB_NAME:-Unknown}" \
                  --arg build "${BUILD_NUMBER:-0}" \
                  --arg version "${APP_VERSION:-N/A}" \
                  --arg author "${GIT_AUTHOR:-Unknown}" \
                  --arg repo "${GIT_REPO:-Unknown}" \
                  --arg branch "${GIT_BRANCH_NAME:-Unknown}" \
                  --arg commit "${GIT_COMMIT_SHORT:-Unknown}" \
                  --arg msg "${GIT_COMMIT_MSG:-No commit message}" \
                  --arg ts "${BUILD_TS:-Unknown}" \
                  --arg buildUrl "${BUILD_URL:-}" \
                  '{
                    embeds: [{
                      title: "❌ Build Failed",
                      color: 15158332,
                      description: (
                        "**Job:** " + $job + "\n" +
                        "**Build:** #" + $build + "\n" +
                        "**Version:** " + $version + "\n" +
                        "**Status:** FAILED\n" +
                        "**Time:** " + $ts + "\n\n" +
                        "👤 **Author:** " + $author + "\n" +
                        "📦 **Repo:** " + $repo + "\n" +
                        "🌿 **Branch:** " + $branch + "\n" +
                        "🔢 **Commit:** " + $commit + "\n" +
                        "📝 **Commit_Message:** " + $msg + "\n\n" +
                        "[View Build Logs](" + $buildUrl + ")"
                      ),
                      footer: {
                        text: "Jenkins CI"
                      }
                    }]
                  }')

                curl -sS -X POST \
                  -H "Content-Type: application/json" \
                  -d "$JSON_PAYLOAD" \
                  "$DISCORD_WEBHOOK_URL"
            '''
        }

        always {
            cleanWs()
        }
    }
}
