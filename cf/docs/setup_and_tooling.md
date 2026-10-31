# Setup and Tooling

The Cloud Foundry CLI is the command-line tool used to interact with a Cloud Foundry environment.
You can use it to:
- Deploy Node.js applications.
- Start, stop and restart applications.
- Scale application instances.
- Inspect application status.
- Read application logs.
- Manage orgs and spaces.
- Inspect routes and quotas.
- Work with platform services.

It communicates with the Cloud Controller API of your Cloud Foundry foundation.

## Logging in and targeting orgs/spaces

### Finding your SAP BTP API endpoint

Before logging in, you need your subaccount's Cloud Foundry API endpoint.

In SAP BTP Cockpit:
1. Open your Global Account.
2. Select the Subaccount.
3. Navigate to Overview.
4. Find the Cloud Foundry Environment section.
5. Copy the API endpoint.

For example, SAP's Frankfurt region uses:
```
https://api.cf.eu10.hana.ondemand.com
```

Other regions have different endpoints.

### Connecting to SAP BTP

**Step 1** — Set the API endpoint
```
cf api https://api.cf.eu10.hana.ondemand.com
```
Replace the example with your actual endpoint.

**Step 2** — Log in
```
cf login --sso
```
The CLI will guide you through browser-based authentication. This is a convenient approach, particularly when your organization uses multifactor authentication.


**Step 3** — Select your org and space

If you belong to multiple orgs or spaces, the CLI will prompt you to select one.

You can also target them explicitly:
```
cf target -o employee-dev-org -s development
```

**Step 4** — Verify your connection
```
cf target
```
Expected output will look conceptually like:

```
API endpoint: https://api.cf.eu10.hana.ondemand.com
User:         developer@example.com
Org:          employee-dev-org
Space:        development
```

Now your CLI is connected and targeting the correct environment.

## CF CLI commands and plugins

Here is a practical starter reference.   
|                         Command   <br> |                              Purpose   <br> |
|:---------------------------------------|:--------------------------------------------|
|                    `cf version`   <br> |                     Show CLI version   <br> |
|                       `cf help`   <br> |              Show available commands   <br> |
|                        `cf api`   <br> |          Set or inspect API endpoint   <br> |
|                `cf login --sso`   <br> |                     Log in using SSO   <br> |
|                     `cf logout`   <br> |                              Log out   <br> |
|                       `cf orgs`   <br> |                            List orgs   <br> |
|                     `cf spaces`   <br> |                          List spaces   <br> |
|                     `cf target`   <br> |                  Show current target   <br> |
|                       `cf apps`   <br> |                    List applications   <br> |
|           `cf app employee-api`   <br> |               Inspect an application   <br> |
| `cf logs employee-api --recent`   <br> |                     View recent logs   <br> |
|          `cf logs employee-api`   <br> |                          Stream logs   <br> |
|                `cf marketplace`   <br> | List available marketplace offerings   <br> |

The CLI stores authentication and target configuration locally, typically under `~/.cf`. Treat this configuration as sensitive because it can contain access tokens.  

### What are CF CLI plugins?

The CF CLI has a built-in set of commands, such as:
```
cf push
cf apps
cf logs
cf services
cf routes
```

Plugins extend the CLI with additional commands.

For example, installing the MultiApps plugin gives you commands such as:

```
cf deploy
cf undeploy
cf mtas
cf mta
```

The important distinction:
- Native CF commands are provided by the CF CLI itself.
- Plugin commands are added by separately installed extensions.

You can inspect installed plugins with:
```
cf plugins
```

You can inspect available plugin repositories with:
```
cf list-plugin-repos
```

And list plugins available from configured repositories with:
```
cf repo-plugins
```

Cloud Foundry plugins are executable programs, so install them only from trusted repositories or publishers. They are not automatically security-vetted.

### Installing a plugin
The standard Cloud Foundry community repository is:

```
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
```

Then install a plugin by its repository name:
```
cf install-plugin -r CF-Community PLUGIN_NAME
```

Verify:
```
cf plugins
```
To remove a plugin:
```
cf uninstall-plugin PLUGIN_NAME
```
To inspect available commands:
```
cf help
```

## SAP BTP CLI

The SAP BTP CLI ( btp) focuses on the broader SAP BTP account structure and administration.
Typical tasks include:
- Inspecting global accounts and directories.
- Listing and managing subaccounts.
- Managing subaccount administrators and members.
- Working with entitlements and account-level configuration.

Example commands:
```
btp --help
btp login --sso
btp get accounts/global-account
btp list accounts/subaccount
```

Exact commands and permissions depend on your account setup and CLI version.

## MultiApps CLI plugin

In a simple Cloud Foundry deployment, you might deploy one Node.js application directly:
```
cf push employee-api
```

But real SAP BTP projects often contain multiple components that need to be deployed together.
For example, an employee management solution might contain:
- employee-api— Node.js backend
- employee-ui— frontend application
- employee-router— application router
- employee-db-deployer— database deployment component

These components can be described in an MTA (Multi-Target Application) descriptor, usually named `mta.yaml`.

The MultiApps plugin lets you deploy and manage the MTA as a single application solution.

Without MTA deployment

```
cf push employee-api
cf push employee-ui
cf push employee-router
```

With MTA deployment `cf deploy employee-management.mtar` deploys the MTA's defined components and resources through the [MultiApps Controller](https://github.com/cloudfoundry/multiapps-controller).

The plugin is a client for the MultiApps Controller, which performs the actual MTA deployment work on the Cloud Foundry landscape.

## Using `CF_HOME` to manage multiple environments

### What problem does CF_HOME solve?

By default, the CF CLI stores its configuration in:
```
~/.cf/
```

The configuration includes information such as:
- API endpoint
- Logged-in user and authentication token
- Currently targeted org
- Currently targeted space

`CF_HOME` allows you to maintain separate CF CLI configuration directories.

Each directory has its own login session, API endpoint, org and space configuration.

### Create separate configuration directories
Let's create three directories:

```
cf-config/
├── development/
├── testing/
└── production/
```

You can put them wherever you like.

The following examples use Linux/macOS shell syntax.

First, create the directories:
```
mkdir -p ~/cf-config/development
mkdir -p ~/cf-config/testing
mkdir -p ~/cf-config/production
```

### Connect to development
Set `CF_HOME` before executing CF commands:

```
export CF_HOME=~/cf-config/development
```

Then log in:
```
cf api https://api.cf.eu10.hana.ondemand.com
cf login --sso
```

Target the development org and space:
```
cf target -o employee-dev-org -s development
```

Check:
```
cf target
```

Your development configuration is now stored separately.

### Connect to testing

In the same terminal, change the configuration directory:
```
export CF_HOME=~/cf-config/testing
```

Then:
```
cf api https://api.cf.eu10.hana.ondemand.com
cf login --sso
cf target -o employee-test-org -s testing
```

Your testing configuration is now independent of development.

### Connect to production
```
export CF_HOME=~/cf-config/production

cf api https://api.cf.eu10.hana.ondemand.com
cf login --sso
cf target -o employee-prod-org -s production
```
You now have three separate CF CLI contexts on one machine.

### Switching between environments
You only need to change the environment variable.
```
export CF_HOME=~/cf-config/development
cf target
```

Or:
```
export CF_HOME=~/cf-config/production
cf target
```

Notice that you don't have to log in every time you switch, provided the saved authentication session is still valid.