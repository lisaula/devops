resource "aws_iam_policy" "vpc_flow_logs_to_cloudwatch" {
  name                      = "AmazonVpcFlowLogsToCloudwatch"

  policy                    = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "vpc_flow_logs" {
  name                      = "AwsVpcFlowLogs"

  assume_role_policy        = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs" {
  policy_arn                = aws_iam_policy.vpc_flow_logs_to_cloudwatch.arn
  role                      = aws_iam_role.vpc_flow_logs.name
}

resource "aws_flow_log" "example" {
  iam_role_arn              = aws_iam_role.vpc_flow_logs.arn
  log_destination           = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type              = "ALL"
  vpc_id                    = aws_vpc.main.id
  tags                      = {
    Name                    = var.cluster_name
  }
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name                      = "${var.cluster_name}_vpc_flow_logs"
}
