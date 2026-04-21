pipeline {
    agent any

    environment {
        APP_VERSION = '1.0.0'
        BUILD_TS = "${new Date().format('dd/MM/yyyy HH:mm:ss')}"
        DISCORD_WEBHOOK_URL = credentials('https://discord.com/api/webhooks/1491988177567744151/I1IO7GeK-avC-XaPkxGkPAOqa7J2cLkbSQDIFeB-Le9EXPK2LgQ-2x-M_heAjbPcvRE3')
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
                    env.GIT_COMMIT_SHORT = sh(
                        script: "git rev-parse --short HEAD",
                        returnStdout: true
                    ).trim()

                    env.GIT_BRANCH_NAME = sh(
                        script: "git branch --show-current",
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
                  '{
                    embeds: [{
                      title: "✅ Build Succeeded",
                      color: 3066993,
                      fields: [
                        {name: "Job", value: $job, inline: true},
                        {name: "Build", value: ("#" + $build), inline: true},
                        {name: "Version", value: $version, inline: true},
                        {name: "Status", value: "SUCCESS", inline: true},
                        {name: "Time", value: $ts, inline: true},
                        {name: "👤 Author", value: $author, inline: false},
                        {name: "📦 Repo", value: $repo, inline: false},
                        {name: "🌿 Branch", value: $branch, inline: false},
                        {name: "🔢 Commit", value: $commit, inline: false},
                        {name: "📝 Commit Message", value: $msg, inline: false}
                      ],
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
                  '{
                    embeds: [{
                      title: "❌ Build Failed",
                      color: 15158332,
                      fields: [
                        {name: "Job", value: $job, inline: true},
                        {name: "Build", value: ("#" + $build), inline: true},
                        {name: "Version", value: $version, inline: true},
                        {name: "Status", value: "FAILED", inline: true},
                        {name: "Time", value: $ts, inline: true},
                        {name: "👤 Author", value: $author, inline: false},
                        {name: "📦 Repo", value: $repo, inline: false},
                        {name: "🌿 Branch", value: $branch, inline: false},
                        {name: "🔢 Commit", value: $commit, inline: false},
                        {name: "📝 Commit Message", value: $msg, inline: false}
                      ],
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