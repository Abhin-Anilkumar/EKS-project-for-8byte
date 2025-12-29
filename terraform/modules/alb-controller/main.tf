resource "aws_iam_role" "alb_controller" {
  name = "eks-alb-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${var.oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

resource "aws_iam_policy" "alb_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWS Load Balancer Controller IAM Policy"
  policy      = data.http.iam_policy.response_body
}

resource "aws_iam_policy_attachment" "alb_policy" {
  name       = "alb-policy"
  roles      = [aws_iam_role.alb_controller.name]
  policy_arn = aws_iam_policy.alb_controller.arn
}

