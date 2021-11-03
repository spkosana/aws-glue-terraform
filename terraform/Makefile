.ONESHELL:
.SHELL := /bin/bash
.PHONY: ALL
.DEFAULT_GOAL := fmt

fmt: ## Formats the TF
	terraform fmt -recursive

removepem: # make removepem key=sample 
	aws ec2 delete-key-pair --key-name $(key) ; rm -rf $(key).pem

pem: # make pem key=sample 
	aws ec2 create-key-pair --key-name $(key) --query 'KeyMaterial' --output text > $(key).pem && \
	chmod 400 $(key).pem ; ls -al $(key).pem

init:
	terraform init

validate: init
	terraform validate 

plan: validate
	terraform plan --out=tfplan

graph:
	terraform graph >> tfplan.svg

apply: 
	terraform apply -auto-approve 

destroy:
	terraform destroy -auto-approve 

ssh: # make ssh key=one ip=12.34.56.789
	ssh -i "$(key).pem" -o StrictHostKeyChecking=no ec2-user@$(ip)

all:
	aws ec2 describe-instances \
    --filters Name=tag-key,Values=Name \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value,InstanceState:State.Name,Environment:Tags[?Key==`environment`]|[0].Value,PublicIp:PublicIpAddress}' \
    --output table

running:
	aws ec2 describe-instances \
	--query 'Reservations[*].Instances[*].{Instance:InstanceId,InstanceState:State.Name}' \
	--filters Name=instance-state-name,Values=running \
	--output table
