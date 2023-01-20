pipelineJob('Hello-World') {
  definition {
    cpsScm {
      scm {
        git {
          branches('*/main')
          remote {
            credentials('github')
            url('https://github.com/vakninf5/Versatile.git')
          }
        }
      }
	  scriptPath('cicd/groovy/Hello-World.groovy')
    }
  }
}