# Sample Deployment - Full

This sample demonstrates a complete application deployment using the [Snap CD Terraform Provider](https://registry.terraform.io/providers/schrieksoft/snapcd/latest/docs), including secrets management, complex module dependencies, and multiple application components.

## Prerequisites

Before deploying this sample, complete the following steps from the [Quickstart Guide](https://docs.snapcd.io/quickstart/):

1. **Create a User Account** - Sign up at [snapcd.io](https://snapcd.io)
2. **Create an Organization** - Set up your organization on first login
3. **Generate Credentials** - Create either:
   - A personal access token for your user, OR
   - A Service Principal with `Organization.Owner` permissions
4. **Register and Deploy a Runner** - Follow the runner deployment instructions
5. **Create a Stack** - Create a Stack (e.g., "samples") via the portal or API
6. **Create Stack Secrets** - Create two secrets in your Stack (see below) and pass their names into the `sample_stack_secret_1_name` and `sample_stack_secret_2_name` variables.


## Variables

This deployment requires the following variables:

| Variable | Description | How to Obtain |
|----------|-------------|---------------|
| `client_id` | The Client ID for authentication | From your Service Principal or personal access token settings |
| `client_secret` | The Client Secret for authentication (sensitive) | Generated when creating your Service Principal or personal access token |
| `organization_id` | Your Snap CD Organization ID | Found in your organization settings |
| `runner_name` | The name of your registered Runner | The name you gave your Runner when registering it |
| `stack_name` | The name of the Stack to deploy to | The name of the Stack you created (e.g., "samples") |
| `sample_stack_secret_1_name` | Name of a Stack Secret with any sample value | The name you gave the secret when creating it |
| `sample_stack_secret_2_name` | Name of a Stack Secret with any sample value | The name you gave the secret when creating it |

### Setting Variables

Create a `terraform.tfvars` file:

```hcl
client_id                  = "your-client-id"
client_secret              = "your-client-secret"
organization_id            = "your-organization-id"
runner_name                = "your-runner-name"
stack_name                 = "samples"
sample_stack_secret_1_name = "storefront-db-password"
sample_stack_secret_2_name = "storefront-api-key"
```

Alternatively, use environment variables:

```bash
export TF_VAR_client_id="your-client-id"
export TF_VAR_client_secret="your-client-secret"
export TF_VAR_organization_id="your-organization-id"
export TF_VAR_runner_name="your-runner-name"
export TF_VAR_stack_name="samples"
export TF_VAR_sample_stack_secret_1_name="storefront-db-password"
export TF_VAR_sample_stack_secret_2_name="storefront-api-key"
```

## What This Sample Creates

This sample creates a mock e-commerce application stack with the following modules:

### Infrastructure Layer
- **VPC** - Virtual network with public/private subnets, environment variables, and lifecycle hooks
- **Cluster** - Kubernetes cluster depending on VPC outputs
- **Database** - Database instance in the private subnet
- **Storage** - Storage account for application assets

### Application Layer
- **Database User (Storefront)** - Database user with password from Stack Secret
- **App Storefront** - Web application with dependencies on cluster, database, and database user
- **Storefront Configuration** - Application configuration with API key from Stack Secret
- **App Worker** - Background worker with dependencies on cluster and storage

## Architecture

```
Stack (e.g., "samples")
└── Namespace (mock)
    │
    ├── Infrastructure
    │   ├── vpc ─────────────────┬──────────────────────────────┐
    │   │                        │                              │
    │   │                        ▼                              ▼
    │   ├── cluster ◄────── from_vpc              database ◄── private_subnet_id
    │   │       │                                     │
    │   │       │                                     │
    │   └── storage                                   ▼
    │           │                           database-user-storefront
    │           │                             │    (+ Secret: db password)
    │           │                             │
    └── Applications                          │
        │                                     │
        ├── app-storefront ◄──────────────────┤
        │   (+ Secret: db password)           │
        │       │                             │
        │       ▼                             │
        ├── storefront-configuration          │
        │   (+ Secret: api key)               │
        │                                     │
        └── app-worker ◄── from_cluster, from_storage
```

## Key Concepts Demonstrated

- **Stack Secrets** - Secure secret management via `snapcd_module_input_from_secret`
- **Output Sets** - Passing all outputs from one module to another via `snapcd_module_input_from_output_set`
- **Single Output** - Passing a specific output via `snapcd_module_input_from_output`
- **Non-String Types** - Using `type = "NotString"` for numeric values (e.g., replicas)
- **Environment Variables** - Passing env vars to module execution
- **Lifecycle Hooks** - Running commands during module lifecycle (`init_before_hook`)
- **Complex Dependencies** - Multi-layer dependency graphs between modules

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply
```