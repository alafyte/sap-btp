# Deploy and Manage Node.js Applications

## `cf push`

cf push is the command used to deploy an application to Cloud Foundry.

It tells Cloud Foundry:
> Take my application, prepare it for execution, create the required runtime resources, and start it.

For the [nestjs-cf](../nestjs-cf/) application:
```
cf push
```

Cloud Foundry reads `manifest.yml` from the current directory by default.

You can also specify the application name:
```
cf push user-management
```

Or specify a different manifest:
```
cf push -f manifest-dev.yml
```

#### What happens internally?

The deployment process can be understood as two major phases:

**Phase 1 — Build and staging**
1. Upload application package
Cloud Foundry receives your application files.
2. Detect buildpack
The Node.js buildpack detects that this is a Node.js application.
3. Install runtime and dependencies
It installs the required Node.js version and application dependencies.
4. Build the droplet
The buildpack prepares the executable application environment.

**Phase 2 — Application execution**
1. Create container
Diego schedules an application instance on a Diego Cell.
2. Download droplet
The Cell receives the prepared application environment.
3. Execute start command
Your application starts using npm run start:prod.
4. Health monitoring
Cloud Foundry monitors the application instance.
5. Route traffic
Gorouter directs incoming requests to healthy application instances.

A useful distinction:
- **Staging** prepares the application.
- **Running** executes the application.

A successful staging operation does not automatically mean the application is running successfully. Both phases must complete.

### What happened during nestjs-cf deployment?   

The successful deployment log confirms this sequence:   

|                      Log evidence   <br> |                                Meaning   <br> |
|:-----------------------------------------|:----------------------------------------------|
| `Downloaded app package (167.7K)`   <br> |    Application source package uploaded   <br> |
|  `Nodejs Buildpack version 1.9.6`   <br> |             Node.js buildpack selected   <br> |
|         `Installing node 22.23.4`   <br> |              Node.js runtime installed   <br> |
|         `Installing pnpm 12.15.0`   <br> |        pnpm installed by the buildpack   <br> |
|                  `Packages: +709`   <br> |                 Dependencies installed   <br> |
|                `Staging complete`   <br> |           Droplet successfully created   <br> |
|     `Downloaded droplet (119.7M)`   <br> | Runtime environment downloaded to Cell   <br> |
|          `Invoking start command`   <br> |          Application startup initiated   <br> |
|                  `node dist/main`   <br> |    NestJS application process launched   <br> |

**Important**: Specify the Node.js version in the package.json or .nvmrc so that the local development and Cloud Foundry runtime use compatible versions.

For example, in package.json:
```json
{
  "engines": {
    "node": "22.x"
  }
}
```

The exact version should be chosen according to the project's compatibility requirements and the versions supported by the buildpack.

## Application manifests



## Environment variables
## Node.js buildpack
## Memory and instance scaling
## Logs and troubleshooting
## Health checks
## Blue-green deployments