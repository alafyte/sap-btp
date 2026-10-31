# SAP BTP Cloud Foundry Environment

Think of SAP BTP as the overall platform where your applications, environments and services are managed.
Cloud Foundry is one of the environments available within SAP BTP. It provides the runtime where the Node.js application will execute.

The account hierarchy is:

![sap-btp-accounts](./images/sap-btp-accounts.png)

This is a conceptual example, not a required account structure. SAP documents the account model as a hierarchy of global accounts, optional directories and subaccounts.

Official reading: [Account Model](https://help.sap.com/docs/btp/btp-admin-guide/account-model).

## Global accounts, directories and subaccounts

### Global Account

A Global Accountrepresents the commercial relationship between the company and SAP.

It is where administrators manage:
- Subaccounts.
- Members and authorizations.
- Entitlements and quotas.
- Directories.
- Overall resource distribution.

For example, the company might have one global account containing development, test and production subaccounts.

### Directories

Directories are optional organizational containers between a global account and subaccounts.

For example:
```Global Account: ACME
│
├── Directory: Europe
│   ├── Subaccount: DEV-EU
│   └── Subaccount: PROD-EU
│
└── Directory: North America
    ├── Subaccount: DEV-US
    └── Subaccount: PROD-US
```

They are useful when an enterprise wants to delegate administration or organize subaccounts by geography, business unit or project.

Directories can also participate in entitlement distribution if entitlement management is enabled for them.

### Subaccounts — where developers start working

A Subaccountis where you configure and consume SAP BTP environments and services.

A subaccount is associated with a region and can contain:
- Cloud Foundry environment.
- Cloud Foundry org and spaces.
- Service instances.
- Application subscriptions.
- Destinations and other configuration.
- Members and authorizations.

For example:

```
Subaccount: employee-dev
Region: Europe (Frankfurt)

Cloud Foundry Environment
  └── Org: employee-dev-org
      └── Space: development
          ├── employee-api
          ├── employee-db
          └── employee-xsuaa
```

## Cloud Foundry orgs and spaces

When you enable the Cloud Foundry environment in a subaccount, SAP automatically creates a Cloud Foundry org.

**One SAP BTP subaccount ↔ one Cloud Foundry org.**

You can then create multiple spaces inside that org.

For example:

```SAP BTP Global Account
  └── Subaccount: employee-dev
      └── Cloud Foundry Org: employee-dev-org
          ├── Space: development
          ├── Space: testing
          └── Space: production
```

The subaccount and org are separate concepts, even though they have a one-to-one relationship in this environment. They may also have different names.

### Why might you use multiple subaccounts instead of multiple spaces?

A useful rule of thumb:
- Use **spaces** to separate application teams or workloads within the same subaccount and environment.
- Use **subaccounts** when you need stronger separation of administration, region, security configuration, service consumption or lifecycle.

For instance, development and production may be placed in separate subaccounts if they require different regions, administrators or service configurations.

## Entitlements and quotas

Imagine you've developed your Node.js application, configured its dependencies and run:
```
cf push employee-api
```
But deployment fails with:
```
Error: organization memory limit exceeded
```

The code might be perfectly fine. The problem could be that the Cloud Foundry environment doesn't have enough allocated memory.

### What is an entitlement?

An entitlementis the organization's right to use a particular SAP BTP service or service plan.

For example, the company might be entitled to use:
- SAP HANA Cloud.
- SAP Authorization and Trust Management service (XSUAA).
- Destination service.
- Cloud Foundry runtime.

A service can offer multiple plans. A plan represents a particular service offering or configuration.

For example, a database service might have different plans for different capacities or capabilities.

Think of an entitlement as:
> "Our company is allowed to use this service plan."

It doesn't necessarily mean that an instance has already been created.

### What is a quota?

A quota is the permitted quantity of a resource.

For example:
- 20 GB of Cloud Foundry runtime memory.
- 10 instances of a particular service plan.
- A limit on the number of routes.
- A limit on the number of application instances.

Think of a quota as:
> "Our company is allowed to consume up to this amount."

The difference:
| Concept | Meaning |
| ------- | ------- |
| Entitlement | Permission to consume a service or plan |
| Quota | Maximum quantity you're allowed to consume |
| Usage | Amount currently consumed |

SAP manages entitlements and quotas at global account level and distributes them to subaccounts, where resources are consumed.

Official reading: [Entitlements and Quotas](https://help.sap.com/docs/btp/sap-business-technology-platform/entitlements-and-quotas).

### How quotas are distributed

Let's use a hypothetical company with 100 GB of Cloud Foundry runtime memory available.

![quota_example](./images/quota_example.png)

An administrator allocates quota to subaccounts. That quota is then available for consumption within the relevant subaccount.

You cannot simply deploy an application using quota that hasn't been allocated to its subaccount.

Official reading: [Managing Entitlements and Quotas Using the Cockpit](https://help.sap.com/docs/btp/sap-business-technology-platform/managing-entitlements-and-quotas-using-cockpit).

### Org quotas and space quotas

In SAP BTP, the runtime quota allocated to a subaccount is reflected in the Cloud Foundry org's resource limits.

The org quota defines the overall resource limits available to its spaces.

You can then distribute those limits using space quota plans.

Let's extend our example:

![space_quotas](./images/space_quotas.png)

This is a simplified memory-only example. Real quota plans can also constrain routes, service instances, application instances and other resources.

The important distinction:
- Org quota: the overall limit for the org.
- Space quota: the limit assigned to a particular space.

Space quotas are optional. If you don't assign one, the space shares the org's quota limits. It does not receive a separate, independent copy of the entire quota.

### Why do space quotas matter?

Suppose the development space uses all 40 GB of the org quota.

The production space might then be unable to deploy another application—even if production itself has very little memory usage.

Space quotas help prevent one space from consuming all the resources available to the org.

### Final Diagram

![sap-btp-hierarchy](./images/sap-btp-hierarchy.png)

## Service Marketplace

The Service Marketplaceis the catalog of services available for consumption in SAP BTP.

For example:
- Database and persistent storage.
- Authentication and authorization.
- Messaging.
- Application monitoring.
- Connectivity to external systems.
- Document management.

SAP and its partners provide these capabilities as platform services.

The Service Marketplace is where you discover the available offerings and their plans.

### Service offerings and service plans

Two terms are particularly important:
- Service offering: the service itself, such as SAP HANA Cloud.
- Service plan: a particular variant of that service, defining capabilities, configuration, capacity or commercial characteristics.

For example, a database offering might provide different plans for different use cases or resource sizes.

The actual plans and their names are service-specific. Don't assume that all services offer the same types of plans.

###  Who controls what appears in the Marketplace?

Not every SAP BTP service is automatically available to every subaccount.

The availability depends on factors such as:
- Your global account's entitlements.
- Which entitlements have been assigned to your subaccount.
- The service's availability in your selected region.
- The environment in which the service can be consumed.

For example, a service may be available for Cloud Foundry but not for Kyma, or vice versa.

This is why two developers working for the same company can see different services in their respective subaccounts.

### Marketplace vs. SAP Discovery Center

Don't confuse these two resources:
| Service Marketplace	| SAP Discovery Center |
| ------------------ | ---------------------- |
| Used to discover and consume available services in your account | Used to explore SAP services, capabilities and solution scenarios |
| Shows offerings and plans available to your subaccount | Provides broader service information and learning material |
| Used during platform administration | Useful during architecture and technology selection |

## SAP-specific Cloud Foundry configurations

### Is SAP BTP Cloud Foundry the same as open-source Cloud Foundry?
Not exactly.

SAP BTP provides a managed Cloud Foundry environmentbased on the open-source Cloud Foundry platform.

SAP operates and maintains the underlying runtime infrastructure. Developers use familiar Cloud Foundry concepts and tools, but they don't administer the complete underlying platform themselves.

Your responsibilities
- Develop Node.js applications
- Configure application resources
- Deploy and monitor apps
- Manage application-level security

SAP's responsibilities
- Operate the managed Cloud Foundry platform
- Maintain the runtime infrastructure
- Manage platform-level components
- Provide platform updates and availability

This is the Platform-as-a-Service model: you manage your applications, while SAP manages the platform infrastructure.

### SAP-specific differences worth knowing

There are several areas where SAP's managed environment differs from a self-managed Cloud Foundry installation.

#### A. Managed infrastructure and platform operations

In a self-managed Cloud Foundry foundation, an operator is responsible for platform installation, configuration, upgrades and infrastructure integrations.

In SAP BTP, SAP takes care of these platform-level operations.

As a developer, you normally interact through:
- SAP BTP Cockpit.
- Cloud Foundry CLI (cf).
- SAP BTP CLI (btp), for account and environment administration.
- APIs and supported developer tools.

You generally don't manage Diego Cells, Gorouter configuration, BOSH deployments or platform-level service brokers directly.4

#### B. Availability zones

SAP BTP's Cloud Foundry environment uses availability zones in supported infrastructure regions.

An availability zone is an isolated infrastructure location within a cloud region.

The goal is to improve resilience by distributing platform workloads across infrastructure failure domains.

#### C. Supported and unsupported Cloud Foundry features

SAP BTP doesn't necessarily support every feature available in an arbitrary open-source Cloud Foundry deployment.

The SAP documentation distinguishes supported and unsupported features. Some examples listed in its Cloud Foundry feature documentation include:

| Feature	| SAP BTP consideration |
| ------	| --------------------- |
| Diego runtime	| Supported |
| SSH into app containers	| Supported |
| Custom domains	| Supported, subject to configuration |
| TCP routing	| Not generally supported |
| Container-to-container networking	| Not supported |
| Isolation segments	| Not supported |
| Docker-based app deployment	| Not supported in the documented feature set |
| Running tasks	| Supported |

The exact support status can depend on the feature and current SAP documentation. Always check before designing around a particular Cloud Foundry capability.

#### D. SAP-managed domains and API endpoints

Every SAP BTP Cloud Foundry environment has a regional API endpoint and application domains.

For example, when connecting the CF CLI, you must use the API endpoint associated with the subaccount's region.

```
# Configure the regional API endpoint
cf api https://api.cf.<region>.hana.ondemand.com

# Log in
cf login

# Select your org and space
cf target -o employee-dev-org -s development
```

The important distinction is that the Cloud Foundry foundation is region-specific. You cannot assume that an endpoint or application domain from another region will work.

#### E. SAP integration and ecosystem

SAP BTP's Cloud Foundry environment is integrated with SAP's broader service ecosystem.

This is one of its biggest advantages compared with using an independent Cloud Foundry installation.

You can build applications that use services such as:
- SAP HANA Cloud for persistence.
- XSUAA for authentication and authorization.
- Destination service for remote-system configuration.
- Connectivity service for access to on-premises systems.
- SAP Event Mesh for asynchronous messaging.

These services are not all part of the open-source Cloud Foundry runtime itself. They are SAP BTP capabilities that integrate with the environment.