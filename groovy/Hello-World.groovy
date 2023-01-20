pipeline {
    agent any

    stages {
        stage('Hello, World!') {
            steps {
                script {
                    script {
                            sh"""
                            echo "Hello, World!" 
                        """
                    }
                }
            }
        }
    }
}
