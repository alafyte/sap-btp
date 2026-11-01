# Services
## Service instances

In Cloud Foundry, applications often depend on external services such as databases, messaging systems, caches, and authentication services.

Instead of installing and managing these services inside your application container, Cloud Foundry allows you to provision them as separate resources.

### What is a service instance?

A service instance is a provisioned instance of a service that an application can consume.

For example, imagine your NestJS application needs PostgreSQL.

You can provision a PostgreSQL service instance in SAP BTP:

![app_with_service](./images/app_with_service.png)

The important distinction is that the database is not running inside your NestJS application container. It is a separate service that your application can connect to.

### Service Marketplace

In SAP BTP, the Service Marketplace is where you discover available services for your subaccount and Cloud Foundry environment.

Examples include:

| Service category    | Example                                     |
| ------------------- | ------------------------------------------- |
| Database            | SAP HANA Cloud                              |
| Relational database | PostgreSQL, where offered by your landscape |
| Messaging           | SAP Event Mesh                              |
| Authentication      | Authorization and Trust Management (XSUAA)  |
| Object storage      | Object Store                                |

Availability depends on your SAP BTP region, entitlements, service plans, and provider configuration.

A service offering describes what a provider makes available. A service plan describes a particular configuration or tier of that offering.

For example:

```
Service Offering: PostgreSQL
    |
    +-- Plan: Development
    |
    +-- Plan: Standard
    |
    +-- Plan: Enterprise
```

These are illustrative plan names, not a claim about the plans available in your subaccount.

### Service offering vs. service plan vs. service instance

This distinction is important.

| Concept          | Meaning                                        |
| ---------------- | ---------------------------------------------- |
| Service offering | The type of service provided                   |
| Service plan     | A particular variant or configuration          |
| Service instance | An actual provisioned resource based on a plan |

Think of it this way:

- Offering = PostgreSQL
- Plan = a particular database tier
- Instance = your actual provisioned database

You can create multiple service instances from the same offering and plan.

### Creating a service instance

There are two common ways to create service instances:

#### Option A — SAP BTP Cockpit

1. Open your SAP BTP subaccount.
2. Navigate to the Cloud Foundry environment.
3. Open the Service Marketplace.
4. Select an available service.
5. Choose a service plan.
6. Create the service instance.

#### Option B — Cloud Foundry CLI

The general command is:

```
cf create-service SERVICE_OFFERING SERVICE_PLAN INSTANCE_NAME
```

For example, using illustrative names:

```
cf create-service postgresql development user-db
```

This asks Cloud Foundry to provision a service instance named `user-db`.

The exact offering and plan names must match what your environment provides.

### Inspecting service instances

Some useful commands:

```
# List all service instances in the targeted space
cf services

# Inspect a specific service instance
cf service user-db

# Show available service offerings and plans
cf marketplace
```

Example output from `cf services` might look like:

```
name       service       plan          bound apps
user-db    postgresql    development   None
```

Notice the `bound apps` column.

At this stage, the service instance exists, but it is not yet connected.


### Creating, updating, and deleting instances

Other lifecycle commands include:

```
# Update an instance's plan, if supported
cf update-service user-db -p standard

# Delete an instance
cf delete-service user-db
```

Be careful with deletion: removing a service instance can result in loss of its associated data, depending on the service provider and its behavior.

## Service keys

### What is a service key?

A service key is a set of credentials generated for a service instance.

For example, imagine you have created a PostgreSQL service instance called `user-db`.

The service provider may generate credentials containing:

```
{
  "hostname": "postgres.example.com",
  "port": 5432,
  "database": "userdb",
  "username": "db_user",
  "password": "generated-secret",
  "ssl": true
}
```

These credentials allow a client to connect to the database.

The exact structure depends on the service provider.

Important: Creating a service key does not create another database. It creates credentials for accessing an existing service instance.

### Creating a service key

Cloud Foundry provides this command:

```
cf create-service-key SERVICE_INSTANCE SERVICE_KEY_NAME
```

For example:

```
cf create-service-key user-db user-db-key
```

This creates a service key called `user-db-key` for the existing `user-db` instance.

To inspect it:

```
cf service-key user-db user-db-key
```

To list the keys:

```
cf service-keys user-db
```

To delete a key:

```
cf delete-service-key user-db user-db-key
```

### Important security considerations

Service keys contain sensitive credentials.

Follow these practices:

- Never commit service-key credentials to Git.
- Never hardcode database passwords in your NestJS source code.
- Restrict access to service keys.
- Delete keys that are no longer required.
- Rotate credentials when necessary, according to the service provider's supported procedures.

Also, a service key does not automatically make a database accessible over the internet. Network access, IP restrictions, and other provider-specific requirements still apply.

## Service bindings

### What is a service binding?

A service binding establishes a relationship between a Cloud Foundry application and a service instance.

For example, your NestJS application needs to connect to PostgreSQL.

You have already provisioned a service instance:

```
Service instance: user-db
Application:      user-management
```

You create a binding between them.

![service_binding](./images/service_binding.png)

The binding allows the service broker to provide the application with the credentials and connection information needed to consume the service.

Important: A binding does not mean that PostgreSQL runs inside your NestJS container. They remain separate resources.

### Creating a service binding using CF CLI

The command is:

```
cf bind-service APP_NAME SERVICE_INSTANCE
```

For your project:

```
cf bind-service user-management user-db
```

This tells Cloud Foundry:

> Bind the PostgreSQL service instance `user-db` to the application `user-management`.

After binding, you generally need to restart the application so the updated environment becomes available to its processes:

```
cf restart user-management
```

You can inspect the binding with:

```
cf services
```

The output might look like:

```
name       service       plan          bound apps
user-db    postgresql    development   user-management
```

The `bound apps` column now shows the application.

### What happens internally?

Let's follow the process.

1. You execute the binding command
   ```
   cf bind-service user-management user-db
   ```
2. Cloud Controller processes the request

   Cloud Controller manages the application and service-binding relationship.
3. The service broker participates

   Cloud Foundry coordinates with the service broker to establish the service binding and obtain the binding credentials.
4. Credentials become available to the application

   Cloud Foundry exposes service information through the system-provided `VCAP_SERVICES` environment variable.
5. The application reads the credentials

   Your NestJS application can read `VCAP_SERVICES` and use the PostgreSQL connection details.

The exact provisioning and credential-generation behavior depends on the service broker and service offering.

### Service bindings in manifest.yml

You can also declare service bindings in your application manifest.

For example:

```yaml
applications:
  - name: user-management
    memory: 512M
    instances: 1
    buildpacks:
      - nodejs_buildpack
    command: npm run start:prod
    services:
      - user-db
```

Here:

```yaml
services:
  - user-db
```

means that the application should be bound to the existing service instance named `user-db`.

When you deploy with:

```
cf push
```

Cloud Foundry processes the declared binding as part of the application deployment configuration.

Note: The service instance must already exist, and the relevant service and plan must be available in your space.

Also, removing a service from the manifest does not necessarily unbind an existing binding automatically. Manage existing bindings explicitly.

### Unbinding a service

Suppose you no longer want your NestJS application to use PostgreSQL.

You can remove the binding:

```
cf unbind-service user-management user-db
```

This removes the application-to-service binding.

It does not normally delete the service instance itself.

To delete the service instance separately:

```
cf delete-service user-db
```

Be careful: deleting a database service instance may result in data loss.

### Service key vs. service binding — final comparison

| Feature               | Service key                      | Service binding                      |
| --------------------- | -------------------------------- | ------------------------------------ |
| Associated with       | Service instance                 | Application and service instance     |
| Credentials           | Generated for independent access | Provided for application consumption |
| Typical consumer      | External client                  | Application                          |
| Credentials retrieval | `cf service-key`                 | `VCAP_SERVICES`                      |
| CLI creation          | `cf create-service-key`          | `cf bind-service`                    |
| CLI deletion          | `cf delete-service-key`          | `cf unbind-service`                  |

One important security distinction: both mechanisms provide access credentials. Neither should be treated as a substitute for network access controls or credential protection.

## `VCAP_SERVICES`
## User-provided services
## Open Service Broker API
## CredHub (conceptual)