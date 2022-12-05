### Service Account Key

You need to create a service account key in the GCP Project 

Go to:

IAM & Admin -> Service Accounts -> Compute Engine default service account -> Keys -> ADD KEY 

Ensure it is a **JSON** key 

It should download to your device

Copy it to your Terraform scripts folder 

Edit the top of **main.tf** to point to the key

Edit the script as necessary e.g. *Cohort numbers* and *count* quantity

Ensure you are in the Terraform scripts directory:

- terraform init 
- terraform plan 
- terraform apply 
- terraform destroy # once finished with the resources

You will need to up your quota for IP addresses.

You will see this error: 

`Error: Error waiting for instance to create: Quota 'IN_USE_ADDRESSES' exceeded. Limit: 8.0 in region europe-west1.`

Request more (approx 25) in the region your script is using e.g. europe-west1

To troubleshoot the start-up script look at the logs: **cat /var/log/syslog**