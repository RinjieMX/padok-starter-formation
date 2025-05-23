# Google GKE Terraform module

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Options](#options)
  - [Monitoring and Logging](#monitoring-and-logging)
  - [Private Cluster](#private-cluster)
  - [Release Channel](#release-channel)
  - [Admission Controller firewalling](#admission-controller-firewalling)
- [Standard](#standard)
  - [Standard Specifications](#standard-specifications)
  - [Standard Dependencies](#standard-dependencies)
  - [Standard Example](#standard-example)
- [Private](#private)
  - [Private Specifications](#private-specifications)
  - [Private Dependencies](#private-dependencies)
  - [Private Example](#private-example)
- [Modules](#modules)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Terraform module which creates **Google Kubernetes Engine** resources on **GCP**.

## Options

### Monitoring and Logging

By default clusters are set up to only log and monitor **system** components. If you don't have any other monitoring or logging solutions you can enable the GCP managed one using:

```terraform
logging    = true
monitoring = true
```

> :warning: Activating this feature is not recommended if you can have another monitoring/logging stack

### Private Cluster

You can have a private control plane using:

```terraform
network {
  private = true
}
```

> :information_source: We recommend you to use this [module](https://library.padok.cloud/catalog/default/component/terraform-google-bastion) to set up an IAP bastion able to access your cluster.

### Release Channel

By default this module sets your cluster on the **REGULAR** release channel but you can modify it:

```terraform
release_channel = "RAPID"
```

### Admission Controller firewalling

By default this module opens those ports between control plane and node pools:

- 8443
- 9443
- 15017

You can add new ones using:

```terraform
network {
  webhook_ports = ["9562"]
}
```

> :information_source: If a port becomes common in our K8S stack don't hesitate to add the port as a default one in this module.

## Standard

### Standard Specifications

- Private nodes
- Public Control Plane
- Zonal Cluster
- Custom Service Account for nodes
- Cilium *(aka Dataplane V2)* enabled
- No Database Encryption (Encrypted secrets in ETCD)
- Firewall rule to allow common admission controllers
- Release channel: **Standard**

### Standard Dependencies

- Subnetwork
- 2 Provisioned Secondary Ranges

> :information_source: You can provision those resources using this [module](https://library.padok.cloud/catalog/default/component/terraform-google-network)

### Standard Example

[Link](https://github.com/padok-team/terraform-google-gke/blob/main/examples/zonal/main.tf)

## Private

### Private Specifications

- Private nodes
- Private Control Plane
- Regional Cluster
- Custom Service Account for nodes
- Cilium *(aka Dataplane V2)* enabled
- No Database Encryption (Encrypted secrets in ETCD)
- Firewall rule to allow common admission controllers
- Release channel: **Standard**

### Private Dependencies

- Subnetwork
- 2 Provisioned Secondary Ranges

> :information_source: You can provision those resources using this [module](https://library.padok.cloud/catalog/default/component/terraform-google-network)

### Private Example

[Link](https://github.com/padok-team/terraform-google-gke/blob/main/examples/regional/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name                                                                                                     | Description                                                                                                                                     | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Default     | Required |
| -------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- | :------: |
| <a name="input_location"></a> [location](#input\_location)                                               | The zone or region to deploy the cluster to. It defines if cluster is regional or zonal                                                         | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | n/a         |   yes    |
| <a name="input_name"></a> [name](#input\_name)                                                           | The name of the GKE cluster.                                                                                                                    | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | n/a         |   yes    |
| <a name="input_network"></a> [network](#input\_network)                                                  | The network parameters used to deploy the resources                                                                                             | <pre>object({<br>    private             = bool              // Determines if the control plane has a public IP or not.<br>    subnet_self_link    = string            // The self link for subnetwork. It's required for shared VPC.<br>    pods_range_name     = string            // The name of pod range created in network.<br>    services_range_name = string            // The name of service range created in network.<br>    master_cidr         = string            // The private ip range to use for control plane. It can not be created in network module.<br>    master_allowed_ips  = list(map(string)) // The ips to whitelist to access master.<br>    webhook_ports       = list(string)      // The ports to open to allow GKE master nodes to connect to admission controllers/webhooks.<br>  })</pre> | n/a         |   yes    |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id)                                       | The project to deploy the ressources to.                                                                                                        | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | n/a         |   yes    |
| <a name="input_registry_project_ids"></a> [registry\_project\_ids](#input\_registry\_project\_ids)       | The project ids on which registry access will be granted.                                                                                       | `list(string)`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 | n/a         |   yes    |
| <a name="input_logging"></a> [logging](#input\_logging)                                                  | Enables Stackdriver logging for workloads                                                                                                       | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `false`     |    no    |
| <a name="input_maintenance_start_time"></a> [maintenance\_start\_time](#input\_maintenance\_start\_time) | Time window specified for daily maintenance operations. Specify start\_time in RFC3339 format 'HH:MM', where HH : [00-23] and MM : [00-59] GMT. | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `"00:00"`   |    no    |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools)                                       | The node pools to create and add to the cluster.                                                                                                | <pre>map(object({<br>    name         = string<br>    locations    = list(string) // Zones to deploy the nodes into<br>    min_size     = string<br>    max_size     = string<br>    machine_type = string // The GCE machine type the pool is made of.<br>    preemptible  = bool<br>    taints       = list(map(string))<br>    labels       = map(string)<br>  }))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `{}`        |    no    |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel)                        | The release channel to look for latest versions on.                                                                                             | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `"REGULAR"` |    no    |
| <a name="input_workload_identity_pool"></a> [workload\_identity\_pool](#input\_workload\_identity\_pool) | Custom workload identity pool to be used, default will be the project default one                                                               | `string`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | `""`        |    no    |

## Outputs

| Name                                                                                                       | Description                                                                  |
| ---------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| <a name="output_command_to_connect"></a> [command\_to\_connect](#output\_command\_to\_connect)             | The gcloud command to run to connect to the cluster.                         |
| <a name="output_node_network_tag"></a> [node\_network\_tag](#output\_node\_network\_tag)                   | If you want to create firewall rules on node pools, use this network tag     |
| <a name="output_workload_identity_pool"></a> [workload\_identity\_pool](#output\_workload\_identity\_pool) | Identity pool for the GKE cluster, used to give access to GCP SA from K8S SA |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```
