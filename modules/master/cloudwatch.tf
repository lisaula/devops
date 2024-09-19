resource "helm_release" "cInsights" {
  name                      = "aws-observability"
  repository                = "https://aws-observability.github.io/aws-otel-helm-charts"
  chart                     = "adot-exporter-for-eks-on-ec2"

  set {
    name                    = "clusterName"
    value                   = var.cluster_name
  }

  set {
    name                    = "awsRegion"
    value                   = local.region
  }

  set {
    name                    = "adotCollector.daemonSet.service.metrics.exporters"
    value                   = "{awsemf}"
  }

  set {
    name                    = "adotCollector.daemonSet.service.metrics.receivers"
    value                   = "{awscontainerinsightreceiver}"
  }
}

module "get_load_balancer_info" {
  source                    = "digitickets/cli/aws"
  aws_cli_commands          = ["--region", local.region, "elbv2", "describe-load-balancers"]
  aws_cli_query             = "LoadBalancers[]"
}

resource "aws_cloudwatch_metric_alarm" "node_cpu_utilization" {
  alarm_name                = "EKS node CPU utilization - ${var.cluster_name}"

  dimensions = {
    ClusterName             = var.cluster_name
  }

  alarm_description         = "Measures EKS node CPU utilization"
  metric_name               = "node_cpu_utilization"
  namespace                 = "ContainerInsights"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 5
  datapoints_to_alarm       = 2
  threshold                 = "95"
  comparison_operator       = "GreaterThanThreshold"
  treat_missing_data        = "missing"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "target_response_time" {
  for_each                  = {for index, value in module.get_load_balancer_info.result: index => value}
  alarm_name                = "ELB TargetResponseTime - ${each.value.LoadBalancerName}"

  dimensions = {
    LoadBalancer            = replace(each.value.LoadBalancerArn, "/\\A.*:loadbalancer\\//", "")
  }

  alarm_description         = "Measures ALB target responsiveness"
  metric_name               = "TargetResponseTime"
  namespace                 = "AWS/ApplicationELB"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 5
  datapoints_to_alarm       = 2
  threshold                 = "5"
  comparison_operator       = "GreaterThanThreshold"
  treat_missing_data        = "missing"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "http_code_target_5xx_count" {
  for_each                  = {for index, value in module.get_load_balancer_info.result: index => value}
  alarm_name                = "ELB HTTPCode_Target_5XX_Count - ${each.value.LoadBalancerName}"

  dimensions = {
    LoadBalancer            = replace(each.value.LoadBalancerArn, "/\\A.*:loadbalancer\\//", "")
  }

  alarm_description         = "Measures ALB 500 error counts"
  metric_name               = "HTTPCode_Target_5XX_Count"
  namespace                 = "AWS/ApplicationELB"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 5
  datapoints_to_alarm       = 2
  threshold                 = "5000"
  comparison_operator       = "GreaterThanThreshold"
  treat_missing_data        = "missing"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}
