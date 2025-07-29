data "aws_iam_policy_document" "alb_permissions" {
  statement {
    actions = [
      "elasticloadbalancing:",
      "ec2:Describe",
      "iam:PassRole",
      "cognito-idp:DescribeUserPoolClient",
      "waf-regional:GetWebACLForResource",
      "wafv2:GetWebACLForResource",
      "shield:GetSubscriptionState",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "alb" {
  name   = "oleg_ALBC_Access"
  policy = data.aws_iam_policy_document.alb_permissions.json
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = var.node_instance_role_name
  policy_arn = aws_iam_policy.alb.arn
}