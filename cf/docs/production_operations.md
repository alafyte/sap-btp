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
## Capacity planning and availability
## Production release management
## Security and secrets management