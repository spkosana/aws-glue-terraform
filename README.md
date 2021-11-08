# Glue Serverless: Terraform 
## Note: Data is not provided. Project is about use case and implementation 
&nbsp;
## Summary: <font size="2">Writing a Glue Etl job to perform the merging of paquet files and deploy it using terraform. Athena is out of scope for this project </font>
&nbsp;
### <u>Aim:</u> <font size="2"><p>To merge small parquet files into larger files. </p> </font>
&nbsp;
### <u> Before ETL Data: Preloaded data from different project - 674000 records</u> <font size="2"><p> I have parquet files in my source bucket. Each of the paruqet file sizes are as below: Total 200 Objects. More parquet files , query has to read the all of them to fetch the records that are needed which in turn take time to complete the task.</font>
* parquet 1: 111KB
* parquet 2: 108KB 
* parquet 3: 120KB </p>
&nbsp;
### After job is complete. Below are the files and their sizes. Total 2 files(Optimum size 200MB - 1GB), used two partitions to write the dataframe into destination bucket.
* Parquet 1: 15.8MB
* Parquet 2: 15.8MB
&nbsp;
### <u>Reason:</u> <font size="2"><p>To optmize the query performance from athena and read fewer partitions to achieve the same results</p></font>
&nbsp;
### <u>ETL Tool:</u> <font size="2"><p>Glue Serverless ETL :AWS Glue is a fully managed ETL (extract, transform, and load) service that makes it simple and cost-effective to categorize your data, clean it, enrich it, and move it reliably between various data stores and data streams. AWS Glue is designed to work with semi-structured data. It introduces a component called a dynamic frame, which you can use in your ETL scripts. A dynamic frame is similar to an Apache Spark dataframe.With dynamic frames, you get schema flexibility and a set of advanced transformations specifically designed for dynamic frames. You can convert between dynamic frames and Spark dataframes, so that you can take advantage of both AWS Glue and Spark transformations to do the kinds of analysis that you want</p></font>
&nbsp;
## Components in Glue ETL job
 * Glue job script
    - Python
 * Glue job parameters
    - JOB NAME
    - SOURCE_S3_LOCATION
    - DESTINATION_S3_LOCATION
 * Job object
 * Job initialization
 * Job commit
&nbsp;
## Approach: Use Glue ETL 2.0: Reference fact_incidents_etl.py in scripts directory.
* Create a Glue job
* Create a Spark context 
* Create a Glue Context using the Spark Context
* Read the smaller parquet files from source
* Use Create Dynamic Dataframe in Glue context to read them into dataframe
* Repartition the dataframe
* Write the dyanmic data frame in glue paruqet format at the destination s3 location
&nbsp;
## <u>Deploy Tool:</u> <font size="2"><p>Terraform :Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently.You describe your infrastructure using Terraform's high-level configuration language in human-readable, declarative configuration files. This allows you to create a blueprint that you can version, share, and reuse.Terraform generates an execution plan describing what it will do and asks for your approval before making any infrastructure changes. This allows you to review changes before Terraform creates, updates, or destroys infrastructure.Terraform can apply complex changesets to your infrastructure with minimal human interaction. When you update configuration files, Terraform determines what changed and creates incremental execution plans that respect dependencies.</p></font>
&nbsp;
## Usage of Terraform
  * terraform fmt: Used for formatting all terraform scripts
  * terraform init: Initialization of terraform scripts to get the resources metadata
  * terraform plan: To look at the plan of what resources will be deployed
  * terraform apply: To deploy all the resources. Infrastructure will be created based on the configuration in the files
  * terraform destory: VERY VERY VERY IMPORTANT: Destroys the infrastructure that is created. 
&nbsp;
## Componets of terraform reference terraform directory

* Terraform to deploy the code into AWS
* Files in the directory: Added hyperlinks to Terraform documentation 
  - [variables.tf](https://www.terraform.io/docs/language/values/variables.html): Declare variables that are being used in the terraform scripts
  - [terraform.tfvars](https://www.terraform.io/docs/language/values/variables.html): Values for variables that are declared in above file
  - [provider.tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs): Used for creating aws infrastucture 
  - [iam.tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role): Create Iam Role for Glue job. Add policies needed for interacting with other AWS services
  - [s3.tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket):Create S3 bucket to store state file in remote location
  - [dynamodb.tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table): Create a dynamodb table to store the lock id which prevents when the process is in progress
  - [backend.tf](https://www.terraform.io/docs/language/settings/backends/s3.html):Creates a remote state file in s3 bucket by using above created dynamodb table
  - [glue.tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job): Creates a glue job and glue trigger(daily).
  - [cw.tf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job): Creates a cloudwatch group to log the activity.
&nbsp;
&nbsp;
## How to use the project: Assuming you have a profile with access and secret key configured (.aws/credentials)
---
* Clone the [Glue project repo](https://github.com/spkosana/aws-glue-terraform). 😀 
* cd aws-glue-terraform
* Change the values accordingly in terraform.tfvars based on your aws selections and configurations
* Change the name of the profile(my profile name is terraform)  that you have your for AWS in the profile value. 
* Change the python script accordingly to give your small parquet files 
* Type "make validate" press return :wink: which initialized and validate all terraform scripts
* Type "make plan" which shows you what will you expect to see in your aws account
* Type "make apply" which will tell install all resources in aws account

@nbsp;
## After above steps You should see following
* s3 bucket Created
* dynamo table created 
* remote file gets created in the s3 bucket.
* iam role created.
* fact_incidents_etl.py copied into scripts directory of your bucket
* Glue trigger for the job scheduled daily ( as per the script)
* Job reads input files from the source location where you have your small parquet files which you have added in the terraform.tfvars
* Final output will be store in the location which you have added in the terraform.tfvars file
* Cloud watch group will be created and you can see the logs of the job
&nbsp;

# DESTORY THE RESOURCES VERY VERY VERY IMPORTANT :ghost:
* Type "make destroy" which destroys all the created resources. DO NOT FORGET THIS STEP! I MEAN IT
&nbsp;

## If any of the above steps are not clear and did not work as expected please feel to let me know. I will do a better job in documenting any missed steps