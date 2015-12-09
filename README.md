# python-mvm-docker
Dockerfile for Python app on Managed VMs

## Instructions

* `git-flow feature start <feature name>` to create a branch.
* Make changes.
* `git push` to push your feature branch up to GitHub.
* Add your feature branch to the [Build Settings](https://hub.docker.com/r/justthunder/python-mvm-docker/~/settings/automated-builds/).  
  Proceed when the build succeeds.
* `git-flow feature finish <feature name>` to close the feature branch and merge into `develop`.
* `git-flow release start <release version>` to create a new release version using [semantic versioning](http://semver.org/).
* Bump the `VERSION` value in `Dockerfile` to match your release version.  
  Edit documentation as needed.
* `git-flow release finish <release version>` to close the release branch and merge into `master`.
* `git checkout master` to change to `local/master` branch.
* `git push` to update `remote/master` branch.
* `git push --tags` to update the remote tags.
* Create a new Tag build on the [Build Settings](https://hub.docker.com/r/justthunder/python-mvm-docker/~/settings/automated-builds/).
