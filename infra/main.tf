
module "ecs" {
    source              = "modules/ecs"
    aws_vpc             = "vpc-d8e011b1"
    env                 = "goreplay"
    cluster             = "gor-demo"
    key_name            = "lf_aws_pair"
    aws_ami             = "ami-1c002379"
    instance_type       = "t2.medium"
    max_size            = 3
    min_size            = 1
    desired_capacity    = 3
    target_group        = "gor-demo"
    health_check_path   = "/"
    aws_region          = "us-east-2"
    vpc_subnets_id      = ["subnet-523dc63b","subnet-4475440e","subnet-4475440e" ]
    ELASTICSEARCH_URL   = "es.gordemo.local"
    ES_PORT             = "9200"

}
