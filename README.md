# aws-provisioner
The AWS Provisioner construct the minimum environment of AWS using terraform.

## Description  
You can build an AWS environment same as this composition diagram.  
All of this setting is for Japan.For example, the time zone is `Asia/Tokyo`.  

<img width="582" alt="2018-02-20 23 45 45" src="https://user-images.githubusercontent.com/11749585/36430335-4ae31934-1698-11e8-8ae5-69da1eb6bd3c.png"> 


## Supported version
Terraform v0.11.0 or higher is recommended.

## Usage
> **Note** Before continue you need to [install terraform](https://www.terraform.io/downloads.html)  and also have an aws accounts.

Clone this repository
```
$ git clone git@github.com:buntafujikawa/aws-provisioner.git
```
 
Create a `terraform.tfvars` and define your resource.
> **Note** Before continue you need to [create a keypair](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-key-pairs.html).

Please enter the version referring this page.  
[MySQL Versions](https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt)  
[PostgreSQL Versions](https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html)  
[MariaDB Versions](https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/CHAP_MariaDB.html)  
 

 
```
$ vim terraform.tfvars
 
Ex)
 
$ cat create terraform.tfvars
# common
aws_access_key = "YOUR ACCESS KEY"
aws_secret_key = "YOUR SECRET KEY"
sitename       = "YOUR SITE NAME"
 
 
# EC2
key_pair_name  = "YOUR KEYPAIR NAME"
 
 
# RDS
db_engine_name    = "mysql" // mysql/postgresql/mariadb
db_engine_family  = "5.7"
db_engine_version = "5.7.19"
 
db_username = "root"
db_password = "hogehoge"
 
production_instance_class = "db.t2.micro" // 「db.t2.micro」is free plan
staging_instance_class    = "db.t2.micro"

```

After creating `terraform.tfvars`, please execute `terraform init`, `terraform plan` and `terraform apply`.

```
$ terraform init
$ terraform plan
$ terraform apply
```


## License
Please see the [LICENSE](https://github.com/buntafujikawa/AWS-provisioner/blob/master/LICENSE) file for details.
