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

### What is a manifest?

An application manifest is a YAML file that describes how Cloud Foundry should deploy and configure your application.

The default filename is:
```
manifest.yml
```

Instead of specifying every deployment option manually through CLI arguments, you declare them in one file.
Think of it as a deployment configuration document.

### The sample manifest

Here's the simplified configuration:

```yaml
---
applications:
  - name: user-management
    command: npm run start:prod
    buildpacks:
      - nodejs_buildpack
```

Let's understand each property.   
|       Property   <br> |                                         Meaning   <br> |
|:----------------------|:-------------------------------------------------------|
| `applications`   <br> |                  List of applications to deploy   <br> |
|         `name`   <br> |               Application name in Cloud Foundry   <br> |
|      `command`   <br> |           Command used to start the application   <br> |
|   `buildpacks`   <br> |      Buildpacks used to prepare the application   <br> |

#### Application name
```
name: user-management
```

This is the name Cloud Foundry uses to identify your application.

You can inspect it using:
```
cf apps
```

#### Start command
```
command: npm run start:prod
```

This corresponds to the [package.json](../nestjs-cf/package.json) script:
```
"start:prod": "node dist/main"
```

So the actual command executed is:
```
node dist/main
```

Remember that the NestJS application must listen on the port assigned by Cloud Foundry:
```
await app.listen(process.env.PORT ?? 3000);
```
Cloud Foundry provides the port through the PORT environment variable.

#### Buildpacks

```yaml
buildpacks:
  - nodejs_buildpack
```

A buildpack prepares the application to run in Cloud Foundry.

For Node.js, it handles things such as:
- Selecting the Node.js runtime.
- Installing dependencies.
- Preparing the application runtime.
- Producing the droplet.

The buildpack does not replace the application build process. It provides the environment in which the application is prepared and executed.

Official reading: [App manifest attribute reference](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest-attributes.html)

### Manifest versus CLI arguments

You can configure deployment through CLI arguments:
```
cf push user-management \
  -i 2 \
  -m 512M
```

Or through a manifest:
```yaml
applications:
  - name: user-management
    instances: 2
    memory: 512M
```

The manifest is generally preferable for repeatable deployments because the configuration is version-controlled alongside your application.

You can also use:
```
cf push -f manifest.yml
```

## Environment variables
## Node.js buildpack
## Memory and instance scaling
## Logs and troubleshooting
## Health checks
## Blue-green deployments