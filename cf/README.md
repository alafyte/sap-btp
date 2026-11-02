# Cloud Foundry Learning Path (SAP BTP)

1. [Cloud Foundry Core Foundations](docs/cf-core-foundations.md)
   - [Cloud Foundry overview and architecture](docs/cf-core-foundations.md#cloud-foundry-overview-and-architecture)
   - [BOSH](docs/cf-core-foundations.md#bosh)
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
4. [Deploy and Manage Node.js Applications](./docs/deploy_and_manage_apps.md)
   - [`cf push`](./docs/deploy_and_manage_apps.md#cf-push)
   - [Application manifests](./docs/deploy_and_manage_apps.md#application-manifests)
   - [Environment variables](./docs/deploy_and_manage_apps.md#environment-variables)
   - [Node.js buildpack](./docs/deploy_and_manage_apps.md#nodejs-buildpack)
   - [Memory and instance scaling](./docs/deploy_and_manage_apps.md#memory-and-instance-scaling)
   - [Logs and troubleshooting](./docs/deploy_and_manage_apps.md#logs-and-troubleshooting)
   - [Health checks](./docs/deploy_and_manage_apps.md#health-checks)
5. [Services](./docs/services.md)
   - [Service instances](./docs/services.md#service-instances)
   - [Service keys](./docs/services.md#service-keys)
   - [Service bindings](./docs/services.md#service-bindings)
   - [`VCAP_SERVICES`](./docs/services.md#vcap_services)
   - [User-provided services](./docs/services.md#user-provided-services)
   - [Open Service Broker API](./docs/services.md#open-service-broker-api)
   - [CredHub (conceptual)](./docs/services.md#credhub-conceptual)
6. [MTA Deployment](./docs/mta_deployment.md)
   - [MTA concepts and architecture](./docs/mta_deployment.md#mta-concepts-and-architecture)
   - [`mta.yaml`](./docs/mta_deployment.md#mtayaml)
   - [MTA modules and resources](./docs/mta_deployment.md#mta-modules-and-resources)
   - [MBT](./docs/mta_deployment.md#mbt)
   - [MTAR archives](./docs/mta_deployment.md#mtar-archives)
   - [`cf deploy`](./docs/mta_deployment.md#cf-deploy)
   - [Deployment and troubleshooting](./docs/mta_deployment.md#deployment-and-troubleshooting)
   - [Blue-green deployments](./docs/mta_deployment.md#blue-green-deployments)
7. [Production Operations](./docs/production_operations.md)
   - [Application monitoring](./docs/production_operations.md#application-monitoring)
   - [Troubleshooting](./docs/production_operations.md#troubleshooting)
   - [Capacity planning and availability](./docs/production_operations.md#capacity-planning-and-availability)
   - [Production release management](./docs/production_operations.md#production-release-management)
   - [Security and secrets management](./docs/production_operations.md#security-and-secrets-management)

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
