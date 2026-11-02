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
## Production release management
## Security and secrets management