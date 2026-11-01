# MTA Deployment

## MTA concepts and architecture

MTA stands for Multi-Target Application.

An MTA is a way to package and deploy an application that consists of multiple related components, potentially running on different runtimes or using different platform services.

For example, a business application might contain:

- A Node.js backend.
- A frontend application.
- An application router.
- A PostgreSQL database service.
- An XSUAA service instance.

Instead of deploying and configuring every component independently, you describe the application and its relationships in an MTA descriptor.

The deployment process then coordinates the components.

### Why do we need MTA?

With a simple `cf push`, you deploy an individual application:

```
cf push user-management
```

But imagine your application grows:

```
user-management/
├── backend/
├── frontend/
├── approuter/
```

Now you may need to:
- Deploy multiple applications.
- Create or reuse service instances.
- Bind services to the correct applications.
- Configure dependencies between modules.
- Update the application as one coordinated deployment.

Managing all these operations manually becomes inconvenient.

MTA provides a declarative way to describe this application landscape.

### MTA architecture

An MTA has two main building blocks:

| Building block | Meaning                                            | Example                                                  |
| -------------- | -------------------------------------------------- | -------------------------------------------------------- |
| Modules        | Deployable application components                  | Node.js backend, App Router, frontend                    |
| Resources      | External services or resources required by modules | PostgreSQL instance, XSUAA instance, destination service |

The modules and resources are described in `mta.yaml`.

Here's a simplified example of an MTA architecture:

![mta_architecture](./images/mta_architecture.png)

### How does MTA deployment work?

There are three important components involved:

| Component            | Responsibility                                                     |
| -------------------- | ------------------------------------------------------------------ |
| MBT                  | Builds the MTA archive from your project and descriptor.           |
| MTAR                 | The packaged deployment artifact.                                  |
| MultiApps Controller | Processes the archive and coordinates deployment on Cloud Foundry. |

The workflow looks like this:

![mta_workflow](./images/mta_workflow.png)

An important distinction: MTA is not another application runtime. The application still runs on the Cloud Foundry runtime. MTA is the packaging and deployment model used to coordinate the application and its dependencies.

## `mta.yaml`
## MTA modules and resources
## MBT
## MTAR archives
## `cf deploy`
## Deployment and troubleshooting
## Blue-green deployments