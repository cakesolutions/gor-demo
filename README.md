# gor-demo
This is a demonstration how to implement a tool to duplicate production traffic (HTTP) into other environments using containers.

## Components
### Servers
The server used for this demonstration it's just a web server with a simple 'Hello World' page which runs on port 80.
This demo is independent of the server used. We chose this one because it fits for our purposes.

For our demonstration we will be using two containers acting like servers. One responding HTTP queries at port 80(serverA), and the other at port 81(serverB)

### Replaying traffic
We will use [Goreplay](https://goreplay.org/) for replay traffic from a production environment into a testing environment.

Goreplay (GOR) can be executed in different modes. You can either intercept traffic and redirect it or you can record it and replay it later.
In this demo , we will do the first.

The request flow will be:

 - User access to http://serverA
 - GOR will capture that request and replay it to http://serverB:81
 - Output for both request and response will be sent to an EK stack (elasticsearch and kibana)



## Requirements
- [Docker](https://www.docker.com/)
- [Terraform](https://terraform.io) >= v0.10.6


## Running locally
Move into `docker` subfolder and run `docker-compose -f docker-compose.yml up`
After a few seconds, the two servers and gor container will be up and running. You can now test it by accessing [http://localhost](http://localhost) (web browser or Curl) and you will see how the very same query (inc. headers) will be executed in serverB (http://localhost:81)

NOTE : If you are using MacOS please go to [Docker for Mac](https://github.com/cakesolutions/gor-demo#docker-for-mac)


## Running in AWS
### Infrastructure
AWS Resources:
* Default VPC with a /16 IP address range and an internet gateway
* Default subnets and the IP ranges.
* ALB and target group for accessing cluster from the outside.
* Internal traffic are routed through internal ELB
* Default subnets are used in the autoscale group which place instances.
* ECS cluster where the instances are connected to and run containers.
* Task definition contain all the instructions of docker containers

### Terraform Variables

Terraform is used for setting up the AWS resources. These are AWS configurations you must provide:

 - `access_key` - This is the AWS access key. It can be sourced from the AWS_ACCESS_KEY_ID environment variable, or via a shared credentials file if profile is specified.

 - `secret_key` - This is the AWS secret key. It can be sourced from the AWS_SECRET_ACCESS_KEY environment variable, or via a shared credentials file if profile is specified.

 - `aws_region` - This is the AWS region. It can be sourced from the AWS_DEFAULT_REGION environment variable, or via a shared credentials file if profile is specified.

These are the variables used for setting up the AWS resources.

- `source`: The Path of the ECS module
- `aws_vpc`: The default ID of the VPC
- `env`: The name of the ECS environment
- `cluster`: The name of the ECS cluster
- `key_name`: The key name that should be used for the instance
- `aws_ami`: The ECS optimized EC2 image ID to launch
- `instance_type`: The size of instance to launch
- `max_size`: The maximum size of the auto scale group
- `min_size`: The minimum size of the auto scale group
- `desired_capacity`: The number of Amazon EC2 instances that should be running in the group
- `target_group`: The unique name of the target group
- `health_check_path`: The destination for the health check request. Default /
- `ELASTICSEARCH_URL`: The URL of the elasticsearch, This must be a one of subdomain of `.perf.local` domain
- `ES_PORT`:  The listening port of elasticsearch cluster


See `infra/main.tf` file for all the default variables.
The variables can be overridden using a variable file:

    aws_vpc = "vpc-xxxxxxxx"
    ecr_account_id = "...."
    aws_region = "us-east-1"
    aws_ami = "ami-xxxxxxxx"

You can then pass these variables when using the Terraform command:

    $ terraform plan -var-file=yourvariables.tfvars

### Run it

Enter the `infra` directory, and run the `terraform` commands directly from there.
These commands initialize Terraform and apply Terraform changes using a custom variables file.

    $ cd infra
    $ terraform init

### Destroy It

Once you're done with the demo, run the `destroy` command:

    $ terraform destroy


## Caveats
### Docker for Mac
There are a few problems with the network driver used by Docker for Mac. So this solution will not work if you are trying to run it in your local environment and you use MacOS.

The only workaround available (at the moment) is spin-up a linux box (vagrant) with docker and execute it in that box.

Here's the issue created in docker's github page about the drama with networking [#68](https://github.com/docker/for-mac/issues/68)

### Elasticsearch & kibana
The output of GOR will be stored in ElasticSearch and visualised through Kibana.

Although this might be useful in some cases, be aware that the output stored will miss some information (And this will not change until the community supporting the driver fix the issue)

If you want, you can change where the output of GOR will be stored by changing the `infra/modules/ecs/templates/goreplay.json` (if you are running this in AWS) or `docker/docker-compose.yml` (if you are running this in your local env)
