# Production Operations

## Application monitoring

### Monitoring vs. observability

| Concept       | Purpose                                                         | Example                                    |
| ------------- | --------------------------------------------------------------- | ------------------------------------------ |
| Monitoring    | Tracks known conditions and alerts when thresholds are exceeded | Alert when memory usage reaches 90%        |
| Observability | Helps investigate why something unexpected happened             | Determine why API response times increased |

Monitoring tells you something is wrong. Observability helps you understand why it is wrong.

### The four areas to monitor

#### A. Application health

- Is the application running?
- Are all expected instances healthy?
- Is the application restarting or crashing?

Useful CF commands:

```
cf app <app-name>
cf events <app-name>
cf crashlogs <app-name>
```

#### B. Performance

- API response time
- Request volume
- HTTP error rate (4xx and 5xx)
- Database query latency

For example, a sudden increase in response time might indicate slow database queries rather than a Cloud Foundry problem.

#### C. Resource consumption

- Memory usage
- CPU usage
- Disk usage
- Instance count

Useful command:

```
cf app <app-name>
```

#### D. Logs and errors

- Application exceptions
- Database connection failures
- Failed requests
- Unexpected restarts

Useful commands:

```
cf logs <app-name>
cf logs <app-name> --recent
```

### Health checks are not full monitoring

Cloud Foundry health checks help determine whether an application instance is healthy enough to run.

For example, the NestJS app might expose:

```js
@Get('/health')
healthCheck() {
  return { status: 'ok' };
}
```

You can configure an HTTP health check in your manifest:

```yaml
applications:
  - name: user-management
    health-check-type: http
    health-check-http-endpoint: /health
```

However, returning HTTP 200 from `/health` does not necessarily mean:

- Database is reachable.
- All application features work.
- API response times are acceptable.
- There are no elevated error rates.

Health checks and production monitoring solve related but different problems.

Cloud Foundry provides application lifecycle and log information, but a production monitoring solution may also need metrics collection, dashboards, alerting, and application-level instrumentation. The exact tools depend on your SAP BTP landscape.

## Troubleshooting

### Start with the symptoms

Imagine users report that the API is unavailable.

Don't immediately restart the application. First, gather evidence.

A useful initial sequence is:

```
cf app user-management
cf events user-management
cf logs user-management --recent
cf crashlogs user-management
```

Each command answers a different question:

| Command            | What you investigate                         |
| ------------------ | -------------------------------------------- |
| `cf app`           | Application state, instances, memory, routes |
| `cf events`        | Recent lifecycle events and failures         |
| `cf logs --recent` | Recent application and platform log output   |
| `cf crashlogs`     | Available crash information for instances    |

### Understand how to correlate the evidence

Suppose you see this situation:

- The application has two configured instances.
- Only one instance is running.
- An instance recently crashed.
- Logs show a PostgreSQL connection error.

A reasonable investigation would be:

1. Check the crash information to understand why the instance exited.
2. Inspect logs around the failure.
3. Check whether the PostgreSQL service is available.
4. Inspect the application's service binding and environment.
5. Determine whether the failure is isolated or affecting both instances.

The important principle is to correlate events and logs by their timestamps. A database error occurring immediately before an instance crash is useful evidence, but it does not automatically prove the database caused the crash.

### Common production incidents

| Symptom                       | Possible causes                                       | What to inspect              |
| ----------------------------- | ----------------------------------------------------- | ---------------------------- |
| Application won't start       | Buildpack, startup command, missing configuration     | Staging logs, recent logs    |
| Instance keeps crashing       | Unhandled exception, memory limit, dependency failure | Crash logs, application logs |
| API returns 500               | Application exception, database failure               | Application logs             |
| API is slow                   | Slow queries, CPU or memory pressure                  | Performance metrics, logs    |
| One instance repeatedly fails | Instance-specific problem or resource pressure        | `cf app`, events, crash logs |
| Deployment fails              | MTA configuration, service operation, staging failure | MTA operation logs           |

### Troubleshooting an MTA deployment

If the application is deployed through an MTA, production troubleshooting also needs to include deployment operations.

Useful commands:

```
# List MTA deployment operations
cf mta-ops

# Inspect the deployed MTA
cf mta user-management

# Inspect a specific deployment operation
cf dmol -i <operation-id>
```

Why does this matter?

An application may work correctly before deployment but fail after an update because:

- A new application version has a startup problem.
- A module configuration changed.
- A required service resource was not available.
- A deployment operation failed partway through.

The MTA operation log helps you investigate the deployment itself, while application logs help you investigate runtime behavior.

### A practical troubleshooting workflow

1. Identify the symptom

Unavailable API, slow requests, crashes, or failed deployment

2. Inspect application state and events

cf app · cf events

3. Inspect logs and crash information

cf logs · cf crashlogs

4. Identify the failing dependency or component

Application · PostgreSQL · configuration · platform · deployment

5. Apply a targeted fix and verify recovery

Production tip: Avoid restarting an application as your first troubleshooting step. A restart can temporarily hide the symptom and remove useful diagnostic context. Capture relevant logs and events first.

## Capacity planning and availability

### Understand the resource model

Cloud Foundry applications have resource limits such as:
- Memory: RAM allocated to each application instance.
- Disk quota: Disk space allocated to each instance.
- Instance count: Number of application instances.

For example, the current configuration is:

```yaml
applications:
  - name: user-management
    memory: 512M
    disk_quota: 1G
    instances: 1
```

This means:

| Setting                             | Value  |
| ----------------------------------- | ------ |
| Instances                           | 1      |
| Memory per instance                 | 512 MB |
| Total application memory allocation | 512 MB |
| Disk quota per instance             | 1 GB   |

### Calculate memory requirements

Cloud Foundry allocates memory per instance.

Suppose you change the configuration:

```yaml
applications:
  - name: user-management
    memory: 512M
    instances: 3
```

Then: 3 x 512 = 1536 MB

Remember: the services have their own resource allocation. Their memory is not included in the application's memory calculation.

### Why multiple instances improve availability

Suppose the application runs with three instances:

- Instance 1 crashes.
- Instances 2 and 3 remain healthy.
- Cloud Foundry can continue routing requests to the remaining available instances.

This improves resilience, but it does not guarantee uninterrupted service.

For example:
- All instances could fail due to the same application bug.
- Database could become unavailable.
- A shared external dependency could fail.
- The application could run out of space or quota.

Important for Node.js servers: multiple instances do not share in-memory state.

If instance 1 stores a user session in memory, instance 2 cannot automatically access it. Use an appropriate shared storage mechanism for state that must be available across instances.

### Quotas and capacity planning

Even if your application manifest requests 3 GB of memory, your space or org must have enough available quota.

For example:

| Application        | Memory allocation |
| ------------------ | ----------------- |
| user-management    | 1.5 GB            |
| order-service      | 1 GB              |
| project-management | 1 GB              |
| Total              | 3.5 GB            |

If your available memory quota is only 3 GB, you cannot allocate all these resources simultaneously.

Useful commands:

```
cf space
cf org
cf apps
cf app user-management
```

Actual quota reporting and available details can depend on your CF landscape and permissions.

### Capacity planning principles

When preparing an application for production:

1. Measure actual memory and CPU usage under realistic load.
2. Estimate expected concurrent traffic.
3. Choose an appropriate instance size.
4. Choose an instance count that supports expected load and failure tolerance.
5. Leave room for deployments, scaling, and temporary resource increases.
6. Revisit capacity as traffic and application behavior change.

Remember that blue-green deployment can temporarily require resources for both old and new application versions. Plan for that extra capacity.

## Production release management

### Application versioning

The MTA descriptor contains an application ID and version:

```yaml
_schema-version: "3.3"
ID: user-management
version: 1.0.0
```

When you prepare a new release, update the version:

```yaml
_schema-version: "3.3"
ID: user-management
version: 1.1.0
```

The distinction:

| Property    | Meaning                                       |
| ----------- | --------------------------------------------- |
| `ID`        | Identifies the MTA application                |
| `version`   | Identifies the MTA release version            |
| Module name | Identifies an individual deployable component |
| MTAR        | Packaged deployment artifact                  |

For the `nestjs-cf` project:

```
user-management
    |
    +-- Version 1.0.0
    |      user-management_1.0.0.mtar
    |
    +-- Version 1.1.0
           user-management_1.1.0.mtar
```

Keep the same MTA ID when releasing a new version of the same application.

### A typical production release process

A release should follow a controlled sequence.

1. Develop

   Implement changes in your NestJS application.
2. Build

   Compile the application and build the MTAR.

   `mbt build -p=cf`
3. Validate

   Check the archive, configuration, dependencies, and version.
4. Deploy

   Deploy the MTAR to the target Cloud Foundry space.

   `cf deploy mta_archives/user-management_1.1.0.mtar`
5. Verify

   Inspect application state, logs, routes, and API behavior.
6. Release

   Confirm the new version is operating correctly and communicate the release.

### Deployment versus release

These concepts are related but different.

- Deployment: Installing or updating the application in the target environment.
- Release: Making that version available for its intended users after the required validation.

For example, a new version could be deployed but not yet released to users while it is being tested.

This distinction is especially useful with blue-green deployment.

### Rollback considerations

Suppose you have:

- Version 1.0.0 running successfully.
- Version 1.1.0 deployed.
- A bug discovered in 1.1.0.

You need a recovery strategy.

There are two important cases:

#### Case A — Application-only changes

If the database schema remains compatible, deploying a previously validated MTAR may be a viable rollback approach.

#### Case B — Database schema changes

This is more complicated.

Imagine version 1.1.0 changes a database column or removes a field that version 1.0.0 expects. Simply deploying version 1.0.0 again may not restore compatibility.

This is why production database changes need careful planning.

### Expand-contract migration strategy

A common approach is:

1. Expand: Add new database structures without immediately removing old ones.
2. Migrate: Update the application to use the new structures.
3. Contract: Remove obsolete structures only after old application versions no longer depend on them.

For example:

```
Release 1.0.0
    Uses: first_name

Release 1.1.0
    Supports: first_name + full_name
    Migrates data to full_name

Release 1.2.0
    Uses: full_name
    Removes first_name (when safe)
```

This helps maintain compatibility during deployments and rollback windows.

**Important**: Keep your MTAR artifacts versioned and stored somewhere reliable. Don't depend on rebuilding an old release from whatever happens to be in your current source branch.

## Security and secrets management