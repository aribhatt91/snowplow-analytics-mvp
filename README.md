# Setup Terraform Config

### Generate SSH Key

Navigate to the project folder `terraform` and create a new folder `keys` if not present and run the following command

```
ssh-keygen -t rsa -b 4096 -f snowplow-mvp-key
```

### Run Terraform

```
cd terraform
```

```
terraform init
```

```
terraform validate
```

If validation is successful, run the next command:

```
terraform plan -var-file="dev.tfvars"
```

terraform state show aws_instance.snowplow_collector

```
terraform apply -var-file="dev.tfvars"
```

Verify the output

```
terraform output collector_endpoint
```

Connect to the EC2 instance

```
ssh -vvv -i "terraform/keys/snowplow-mvp-key" ubuntu@<COLLECTOR_ENDPOINT>
```

### Tear down the environment

```
terraform destroy
```

### Start, Stop and Terminate EC2 instance from commandline

Check the state of the EC2 instance Run the following command:

```
terraform state show aws_instance.snowplow_collector
```

and get the id of the EC2 instance. (Something like "id = i-xxxxxxxxxxx")

To start the instance:

```
aws ec2 start-instances --instance-ids i-xxxxxxxxxxx
```

To stop the instance:

```
aws ec2 stop-instances --instance-ids i-xxxxxxxxxxx
```

AWS will gracefully shut down the instance.

To tetminate an instance:

```
aws ec2 terminate-instances --instance-ids i-xxxxxxxxxxx
```

You may verify the status of the instance:

```
aws ec2 describe-instances --instance-ids i-xxxxxxxxxxx --query "Reservations[0].Instances[0].State.Name"
```

### Move the collector configuration into EC2 instance

You must attach a role to the EC2 instance with the following policy:

```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "WriteSnowplowEventsToKinesis",
			"Effect": "Allow",
			"Action": [
				"kinesis:PutRecord",
				"kinesis:PutRecords"
			],
			"Resource": [
				"arn:aws:kinesis:eu-north-1:<AWS-ACCOUNT-ID>:stream/snowplow-raw-good",
				"arn:aws:kinesis:eu-north-1:<AWS-ACCOUNT-ID>:stream/snowplow-raw-bad"
			]
		}
	]
}
```

This enables EC2 to write to Kinesis streams.
SSH into the EC2 instance and create the following directory.

```
mkdir -p /home/ubuntu/snowplow
```

Run the following to copy the Collector configuration into EC2 Instance

```
scp -i "terraform/keys/snowplow-mvp-key-v2" -r ".\collector" ubuntu@13.50.108.162:/home/ubuntu/snowplow/
```
