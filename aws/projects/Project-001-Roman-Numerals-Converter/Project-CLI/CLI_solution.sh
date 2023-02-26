aws ec2 create-security-group --group-name WebSwcGrp

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

aws ssm get-parameters \
    --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \ 
    --region us-east-1   

aws ssm get-parameters \
    --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
    --query 'Parameters[0].[Value]' \
    --output text    

LATEST_AMI=$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --query 'Parameters[0].[Value]' --output text)

aws ec2 run-instances \
    --image-id $LATEST_AMI \
    --instance-type t2.micro \
    --key-name firstkey \
    --security-groups WebSecGrp \
    --tag-specifications 'ResourceType=instance, Tags=[{Key=Name, Value=roman_numbers}]' \
    --user-data file:///< file-path>

aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers"

aws ec2 describe-instances --filters "Name=tag:Name,Values=roman_numbers" --query 'Reservations[].Instances[].PublicIpAddress[]'

aws ec2 terminate-instances --instance-ids "..."

aws ec2 delete-security-group --group-name WebSecGrp