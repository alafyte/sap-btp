# Cloud Foundry Learning Path (SAP BTP)

1. [Cloud Foundry Core Foundations](docs/cf-core-foundations.md)
   - [Cloud Foundry overview and architecture](docs/cf-core-foundations.md#cloud-foundry-overview-and-architecture)
   - [Diego architecture and scheduling](docs/cf-core-foundations.md#diego-architecture-and-scheduling)
   - [Staging and buildpacks](docs/cf-core-foundations.md#staging-and-buildpacks)
   - [Orgs, spaces, roles and permissions](docs/cf-core-foundations.md#orgs-spaces-roles-and-permissions)
   - [Networking and HTTP routing](docs/cf-core-foundations.md#networking-and-http-routing)
2. [SAP BTP Cloud Foundry Environment](./docs/sap-btp-cf-env.md)
   - [Global accounts, directories and subaccounts](./docs/sap-btp-cf-env.md#global-accounts-directories-and-subaccounts)
   - [Cloud Foundry orgs and spaces](./docs/sap-btp-cf-env.md#cloud-foundry-orgs-and-spaces)
   - [Entitlements and quotas](./docs/sap-btp-cf-env.md#entitlements-and-quotas)
   - [Service Marketplace](./docs/sap-btp-cf-env.md#service-marketplace)
   - [SAP-specific Cloud Foundry configurations](./docs/sap-btp-cf-env.md#sap-specific-cloud-foundry-configurations)
3. [Setup and Tooling](./docs/setup_and_tooling.md)
   - [Logging in and targeting orgs/spaces](./docs/setup_and_tooling.md#logging-in-and-targeting-orgsspaces)
   - [CF CLI commands and plugins](./docs/setup_and_tooling.md#cf-cli-commands-and-plugins)
   - [SAP BTP CLI](./docs/setup_and_tooling.md#sap-btp-cli)
   - [MultiApps CLI plugin](./docs/setup_and_tooling.md#multiapps-cli-plugin)
   - [Using `CF_HOME` to manage multiple environments](./docs/setup_and_tooling.md#using-cf_home-to-manage-multiple-environments)
4. Deploy and Manage Node.js Applications
   - `cf push`
   - Application manifests
   - Environment variables
   - Node.js buildpack
   - Memory and instance scaling
   - Logs and troubleshooting
   - Health checks
   - Blue-green deployments
5. Services and Service Bindings
   - Service Marketplace
   - Service instances
   - Service keys
   - Service bindings
   - `VCAP_SERVICES`
   - User-provided services
   - Open Service Broker API
   - CredHub (conceptual)
6. SAP BTP Authentication and Authorization
   - OAuth 2.0
   - XSUAA
   - JWT
   - Scopes and role templates
   - Role collections
   - `@sap/xssec`
   - Token propagation
7. Application Router and Destinations
   - Application Router architecture
   - `@sap/approuter`
   - `xs-app.json`
   - Authentication through App Router
   - Destination service
   - Connectivity service
   - Cloud Connector
8. MTA Deployment
   - MTA concepts and architecture
   - `mta.yaml`
   - MTA modules and resources
   - MBT
   - MTAR archives
   - `cf deploy`
   - Deployment and troubleshooting
9. Production Operations
   - Application monitoring
   - Logging and troubleshooting
   - Scaling and availability
   - Application updates
   - Deployment strategies
   - Security and secrets management

## Official documentation to bookmark

| Resource | What to learn |
| -------- | ------------- |
| [Cloud Foundry](https://docs.cloudfoundry.org/#read-the-docs) | Official Cloud Foundry documentation |
| [SAP BTP Cloud Foundry Environment](https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/9c7092c7b7ae4d49bc8ae35fdd0e0b18.html) | Platform architecture and SAP-specific configuration |
| [Developing Node.js in Cloud Foundry](https://help.sap.com/docs/btp/sap-business-technology-platform/developing-node-js-in-cloud-foundry-environment?locale=en-US\&scp-env=Cloud+Foundry) | Node.js development and buildpacks |
| [Application Router](https://help.sap.com/docs/btp/sap-business-technology-platform/application-router?locale=en-US) | Routing and authentication |
| [Application Routes and Destinations](https://help.sap.com/docs/btp/sap-business-technology-platform/application-routes-and-destinations) | Backend connectivity |
| [MTA Applications](https://help.sap.com/docs/btp/sap-business-technology-platform/applications) | MTA deployment |
| [Development in Cloud Foundry](https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/40a8f8f6f1724e0ca0fd2a8777f45504.html?locale=en-US) | SAP BTP development lifecycle |
