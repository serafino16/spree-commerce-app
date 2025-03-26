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

EKS_IRSA:Config for iam for service account with oidc token and necessary policies and permissions.

EKS-IRSA files:generic-variables.tf,iam-oidc-connect-provider-variables.tf,iam-oidc-connect-provider.tf,irsa-iam-policy-and-role.tf,local-values.tf,provider.tf

Ingress controller: two ingress controllers,one internet-facing for alb for forntend and spree api with ssl redirect,health checks and conncected to route 53 public hosted zone and one internal with nlb for backend serives and database also with health checks.

IAM-ADMIN: Config for Administrator of the eks cluster

EBS:ebs volume for RDS with dynamic provisioning with storageclass and csi-addon to enable the storage interface and volume claim for the ebs.

EBS files:ebs-configmap.tf,ebs-csi-addon.tf,ebs-pvc.tf,output.tf,storageclass.tf,versions.tf

EFS: file system for centralised storage for backend services with efs-csi ,storageclass and pvc for dynamic provisioning and necessary iam policies.

EFS files:efs-csi-datasources.tf,efs-csi-iam-policy-and-role.tf,efs-csi-install.tf,efs-resource.tf,outputs.tf,provider.tf,pvc.tf,storage-class.tf

Route53: config for internal and external dns and hosted zones.File iclude ExternalDNS.tf,InternalDNS.tf,route53-hosted-zones.tf

Lambda: serverless functions working with the spree api and payment gateway for PaymentConfirmation,RefundPayment,SyncPayment

RDS: relational database for PostgreSQL with components like rds cluster and instance parameter groups,connection to database subnet,security groups and iam policies.Files include rds-iam.tf,rds-output.tf,rds.tf

Redis: redis cluster configured with elasticcache for database caching on a standalone mode and connection to database subnet with iam policies and security groups.




 



