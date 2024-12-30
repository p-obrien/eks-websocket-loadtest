
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.11"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodepool = {
      instance_types = ["m7a.large"]
      capacity_type  = "SPOT"
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      ami_type       = "AL2023_x86_64_STANDARD"

      iam_role_additional_policies = {
        cloudwatch_agent_policy = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }
    }
  }

}

resource "aws_eks_addon" "amazon_cloudwatch_observability" {

  cluster_name  = var.cluster_name
  addon_name    = "amazon-cloudwatch-observability"
  addon_version = "v2.6.0-eksbuild.1"

  #  configuration_values = local.amazon_cloudwatch_observability_config
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name}"
}
