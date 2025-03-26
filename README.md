Spree is an open-source eCommerce framework. The application consist of 5 microservices: Spree Core – Handles the core functionality of the store like product management, orders, and checkout. Spree API – Provides an API for integrating with other applications. Spree Frontend – A customizable frontend for the store, typically built using React or another framework. Spree Admin – The admin interface for managing the e-commerce store. Spree Payments – Manages payments and integrates with third-party payment gateways.PostgreSQL for relational database.Redis for cache.

Docker : the application is written in ruby and i choose this image ruby:3.1.0-alpine for backend services, for the frontend node:16-alpine,for Database postgres:13 and for redis redis:7.2-alpine

Kubernetes services : you can check the folder services ,every file is combined to have deployment,service and service account. 
Deployment file  consist of replicas,image from ecr,service account name,resource request and limit,livness and readiness probe volume mount for efs for backend services and ebs for database.
Service account is connected to eks-irsa
Service contains load balancers with annotations for external serives is used ALB,for internal is used NLB.
Database  contains headless service and also vertical load balancer and secret.

Jenkins: for CI/CD i use jenkins with the following stages  1 Git checkout 2 Docker build 3 Docker Push to ECR 4 Deploy to EKS

EKS: for the cluster i use eks with the following resources- cluster main file for connected to vpc,public and private node groups,cluster autoscaler and IAM policies and roles for this components.
EKS files:Cluster-Autoscaler.tf,autoscaler-iam-policy-and-role.tf,ecr.tf,eks-cluster.tf,eks-outputs.tf,eks-variables.tf,eks.auto.tfvars,iam-for-NodeGroup.tf,iam-for-cluster.tf,node-group-private.tf,node-group-public.tf.

VPC:components for the network include public,private and database subnets,nat gateway,dns hostname,route table,availability zones,and vpc name.
VPC files:generic-variables.tf,lacal-values.tf,terraform.tfvars,versions.tf,vpc-auto.tfvars,vpc-module.tf,vpc-outputs.tf,vpc-variables.tf


 



