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

## Service Marketplace

## SAP-specific Cloud Foundry configurations