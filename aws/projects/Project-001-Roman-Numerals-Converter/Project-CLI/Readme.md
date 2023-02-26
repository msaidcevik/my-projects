- We create Security Group (22, 80) and EC2 instance with aws cli.

1. Create Security Group

```bash
aws ec2 create-security-group \
    --group-name WebSecGrp \
    --description "Allow SSH(22) and HTTP(80) ports"
```
- We can check the security Group with these commands
```bash
aws ec2 describe-security-groups --group-names WebSecGrp
```

2. Create Rules of security Group

```bash
aws ec2 authorize-security-group-ingress \
    --group-name WebSecGrp \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name WebSecGrp \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0
```

3. After creating security Groups, We'll create our EC2 which has latest AMI id. to do this, we need to find out latest AMI with AWS system manager (ssm) command

- This command is to get description of latest AMI ID that we use.
```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1
```
- This command is to run querry to get latest AMI ID
```bash
aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text
```

- we'll assign this latest AMI id to the LATEST_AMI environmental variable

```bash
LATEST_AMI=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text)
```

- Now we can run the instance with CLI command. (Do not forget to create userdata.sh under "/home/ec2-user/" folder before run this command

```bash
aws ec2 run-instances \
    --image-id $LATEST_AMI \
    --instance-type t2.micro \
    --key-name firstkey \
    --security-groups WebSecGrp \
    --tag-specifications 'ResourceType=instance, Tags=[{Key=Name, Value=roman_numbers}]' \
    --user-data file:///<file-path>
```    

- To see the each instances Ip we'll use describe instance CLI command
```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers"
```

- You can run the query to find Public IP and instance_id of instances:
```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers" --query 'Reservations[].Instances[].PublicIpAddress[]'

aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers" --query 'Reservations[].Instances[].InstanceId[]'
```

- To delete instances
```bash 
aws ec2 terminate-instances --instance-ids <We have already learned this id with query on above>
```

- To delete security groups
```bash
aws ec2 delete-security-group --group-name WebSecGrp
```