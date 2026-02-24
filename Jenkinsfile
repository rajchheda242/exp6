pipeline {
    agent any
    
    stages {
        stage('Setup') {
            steps {
                echo 'Setting up Python virtual environment...'
                sh '''
                    cd ${WORKSPACE}
                    python3 -m venv .venv
                    . .venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('Run Flask App') {
            steps {
                echo 'Starting Flask application...'
                sh '''
                    cd ${WORKSPACE}
                    . .venv/bin/activate
                    
                    # Kill any existing Flask process on port 5000
                    lsof -ti:5000 | xargs kill -9 || true
                    
                    # Start Flask app in background
                    nohup python app.py > app.log 2>&1 &
                    echo $! > flask.pid
                    
                    # Wait for app to be ready
                    chmod +x wait_for_app.sh
                    ./wait_for_app.sh
                '''
            }
        }
        
        stage('Test') {
            steps {
                echo 'Testing Flask application...'
                sh '''
                    curl -f http://127.0.0.1:5000/
                    echo "Flask app is responding correctly!"
                '''
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            sh '''
                # Kill Flask app if running
                if [ -f ${WORKSPACE}/flask.pid ]; then
                    kill $(cat ${WORKSPACE}/flask.pid) || true
                    rm ${WORKSPACE}/flask.pid
                fi
                lsof -ti:5000 | xargs kill -9 || true
            '''
        }
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed. Check app.log for details.'
            sh 'cat ${WORKSPACE}/app.log || true'
        }
    }
}
