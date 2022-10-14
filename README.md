# MONOREPO CI/CD EXAMPLE

## THE PROBLEM
In this example, we are given multiple apps inside Mono Repository. The problem is how will each application in the future can be deployed separately. So that it will be easier to manage at the infrastructure level for example, scaling. 

## THE SOLUTION
We will create a pipeline that can separate each application to have its own build image so that in the future each application can deploy independently.

## How To

![flow](https://i.ibb.co/GW8npmY/Screenshot-2022-10-14-at-12-39-42-PM.png)

When developers make a new commit, the pipeline will looks for how many apps have changed in the apps/* directory. When one or more applications change in the code, the Github action will trigger a number of jobs according to the number of applications that changed in the commit.

### Description of the Jobs
The whole workflow consist of three jobs

1. `initialize`: On the first job, it will gather all apps that changed and will be set as output that later will be used for matrix input on the second job
2. `build`: This Job depends on `initialize` and will only trigger if there is at least one changes in apps/* directory. This job will create docker image and push to docker registry. And also storing some manifest files for deployment into github artifact. Manifest files contains repository name and tag.
3. `deploy`: In this case, we can get manifests from artifact and use it to trigger deployment (TBD).
 

List of docker repositories for this case.
- `docs`: https://hub.docker.com/r/geralvinmaheswara/monorepo-docs
- `web`: https://hub.docker.com/r/geralvinmaheswara/monorepo-web

### Technical consideration
- `using github matrix`: Doing the entire build process in one job can raise some concerns such as:  
   1. The build process will take longer because the process is done sequentially
   2. If there is a build failure in one particular application, the entire workflow will fail
   3. Application that don't have any changes will also generate an unnecessary docker image

   Hence, using github matrix to trigger multiple jobs can eliminate some of the concerns above because:
   1. Build process running in parallel
   2. If there is a build failure, other process will still continue running
   3. Only generate necessary docker images

### Tools

- `turborepo`: High-performance build system for JavaScript and TypeScript codebases
- `docker`: Containerization tools
- `github actions`: CI/CD Platform

### Trade-offs
- In this workflow, all application only can build under same version/tag. It's better to use this workflow only for development. For production, version registered on package.json on every application can be solution for image version.

### Future Development

- Since this repository not covering how application will be deployed. At least the manifest on Job `deploy`  can be used  to trigger deployment. For example, we can do patching on kubernetes manifest.
![manifest](https://i.ibb.co/F7Vzxvg/Screenshot-2022-10-14-at-12-56-18-PM.png)

- All applications are included in docker in the build process. In the future, it would be better if only copy application to docker that match the job being run in order to reduce the size of the created docker image.

## About
[Geralvin Maheswara](https://www.linkedin.com/in/geralvin-maheswara-b1153259/)
