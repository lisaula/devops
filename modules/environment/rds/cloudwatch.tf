resource "aws_cloudwatch_metric_alarm" "disk_queue_depth" {
  alarm_name                = "RDS disk queue depth - rds-${var.environment}"

  dimensions = {
    DBInstanceIdentifier    = "rds-${var.environment}"
  }

  alarm_description         = "Measures RDS disk queue depth"
  metric_name               = "DiskQueueDepth"
  namespace                 = "AWS/RDS"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 5
  datapoints_to_alarm       = 2
  threshold                 = "10000"
  comparison_operator       = "GreaterThanThreshold"
  treat_missing_data        = "missing"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name                = "RDS CPU utilization - rds-${var.environment}"

  dimensions = {
    DBInstanceIdentifier    = "rds-${var.environment}"
  }

  alarm_description         = "Measures RDS CPU utilization"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/RDS"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 5
  datapoints_to_alarm       = 2
  threshold                 = "10000"
  comparison_operator       = "GreaterThanThreshold"
  treat_missing_data        = "missing"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  alarm_name                = "RDS free storage space - rds-${var.environment}"

  dimensions = {
    DBInstanceIdentifier    = "rds-${var.environment}"
  }

  alarm_description         = "Measures RDS free storage space"
  metric_name               = "FreeStorageSpace"
  namespace                 = "AWS/RDS"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 5
  datapoints_to_alarm       = 2
  threshold                 = "100000000"
  comparison_operator       = "LessThanThreshold"
  treat_missing_data        = "missing"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory" {
  alarm_name                = "RDS freeable memory - rds-${var.environment}"

  dimensions = {
    DBInstanceIdentifier    = "rds-${var.environment}"
  }

  alarm_description         = "Measures RDS freeable memory"
  metric_name               = "FreeableMemory"
  namespace                 = "AWS/RDS"
  statistic                 = "Average"
  period                    = 300
  evaluation_periods        = 5
  datapoints_to_alarm       = 2
  threshold                 = "100000000"
  comparison_operator       = "LessThanThreshold"
  treat_missing_data        = "missing"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}
