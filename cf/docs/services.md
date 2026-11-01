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
## Service bindings
## `VCAP_SERVICES`
## User-provided services
## Open Service Broker API
## CredHub (conceptual)