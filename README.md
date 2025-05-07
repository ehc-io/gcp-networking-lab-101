# GCP Networking Lab 101

A Terraform-based lab environment demonstrating core Google Cloud Platform networking concepts with multiple VPCs, VPN connectivity, and hybrid networking.

## Architecture Overview

This lab creates the following infrastructure:

* **3 VPC Networks** across different regions:
  * `vpc-east` (us-east1): 192.168.10.0/24
  * `vpc-central` (us-central1): 192.168.20.0/24
  * `vpc-west` (us-west1): 192.168.30.0/24

* **HA VPN Connectivity** between vpc-west and vpc-central:
  * BGP-based dynamic routing with ASNs 64514 (west) and 64515 (central)
  * Redundant tunnels for high availability
  
* **Static Route Connectivity** from vpc-west to vpc-east:
  * Routes configured in static-routes.tf for traffic flow

* **VM Instances** (one per VPC):
  * `i-east`: 192.168.10.5
  * `i-central`: 192.168.20.5
  * `i-west`: 192.168.30.5

* **Cloud NAT** for outbound internet connectivity in all VPCs

* **Firewall Rules** for SSH access and internal communication

* **Static Routes** for connectivity between networks

## Prerequisites

Before you begin, you'll need:

1. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
2. [Terraform](https://www.terraform.io/downloads.html) installed (v0.13+ recommended)
3. A Google Cloud Platform account with billing enabled
4. Permissions to create projects and resources

## Deployment Instructions

1. Clone this repository:
   ```
   git clone https://github.com/ehc-io/gcp-networking-lab-101.git
   cd gcp-networking-lab-101
   ```

2. Update the `variables.tf` file with your specific values:
   * `project_id`: A unique project ID
   * `billing_account`: Your GCP billing account ID
   * `google_folder`: The folder ID where the project will be created (optional)

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Plan the deployment:
   ```
   terraform plan
   ```

5. Apply the configuration:
   ```
   terraform apply
   ```

6. Confirm by typing `yes` when prompted

## Network Diagram

The lab creates the following network architecture:

```
+---------------+       +---------------+       +---------------+
|    vpc-east   |-------|  vpc-central  |       |   vpc-west    |
| 192.168.10/24 | Peering| 192.168.20/24|       | 192.168.30/24 |
|   (us-east1)  |       | (us-central1) |       |  (us-west1)   |
+-------+-------+       +-------+-------+       +-------+-------+
        |                       |                       |
        |                       |                       |
+-------v-------+       +-------v-------+       +-------v-------+
|    i-east     |       |   i-central   |       |    i-west     |
| 192.168.10.5  |       | 192.168.20.5  |       | 192.168.30.5  |
+---------------+       +---------------+       +---------------+
                                ^                       ^
                                |                       |
                                +-------HA VPN----------+
                                |  BGP Peering ASNs    |
                                | 64515 <--> 64514     |
                                +---------------------+
```

## Testing Connectivity

After deployment, you can test connectivity by:

1. SSH into one of the instances using Google Cloud Console or gcloud:
   ```
   gcloud compute ssh i-west --project=YOUR_PROJECT_ID --zone=us-west1-b
   ```

2. Ping instances in other VPCs:
   ```
   # From i-west to i-central
   ping 192.168.20.5
   
   # From i-west to i-east (if routes are properly configured)
   ping 192.168.10.5
   ```

3. Test internet connectivity through Cloud NAT:
   ```
   curl google.com
   ```

## Key Learning Objectives

This lab demonstrates:

* Multi-VPC networking in different regions
* HA VPN configuration with BGP-based dynamic routing
* Static routes for custom network paths
* Cloud NAT for outbound connectivity
* Firewall rules for network security
* VM instance deployment across multiple VPCs

## Cleanup

To avoid incurring charges, remember to destroy the resources when you're done:

```
terraform destroy
```

Confirm by typing `yes` when prompted.

## Notes

* The VPN shared secret in this lab is for demonstration purposes only. You should always use a strong, unique secret in production environments.
* This lab uses e2-micro instances to minimize costs during experimentation.
* VPC peering between vpc-east and vpc-central (shown in diagram) can be enabled by uncommenting the peering resources in `networking.tf`.
* Static routes are configured to allow traffic from vpc-west to vpc-east through the VPN connection.

## Contributors

- ehc-io team

## License

This project is licensed under the MIT License - see the LICENSE file for details.