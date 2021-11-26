# AsyncAPI Kubernetes cluster on Digital Ocean

Digital Ocean provides a managed Kubernetes cluster on their cloud.
This Terraform module allows you to create such a cluster by using the official [Digital Ocean Terraform Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/kubernetes_cluster).

## Prerequisites

* Install [Terraform](https://www.terraform.io/).
* Generate a [Digital Ocean API token](https://cloud.digitalocean.com/account/api/).

## Run

If this is your first time, you will need to run the following command:

```bash
terraform init
```

Then you can run the following command to apply changes:

```bash
DIGITALOCEAN_TOKEN=<your-token> terraform apply
```

## Customize cluster properties

The cluster properties can be customized by setting any of the variables available at `variables.tf`.
All you need to do is create your own variables file `main.tfvars` and set the variables you want to customize. I.e.:

```terraform
region = "sfo2"
cluster_name = "my-awesome-cluster"
cluster_node_count_min = 5
```

Then, apply the changes:

```bash
DIGITALOCEAN_TOKEN=<your-token> terraform apply -var-file=main.tfvars
```