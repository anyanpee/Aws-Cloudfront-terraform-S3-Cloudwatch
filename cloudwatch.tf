# CloudWatch monitoring for performance tracking
resource "aws_cloudwatch_log_group" "cloudfront_logs" {
  name              = "/aws/cloudfront/access-logs"
  retention_in_days = 30
}

# CloudWatch dashboard for monitoring
resource "aws_cloudwatch_dashboard" "cloudfront_dashboard" {
  dashboard_name = "CloudFront-Performance"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/CloudFront", "Requests", "DistributionId", aws_cloudfront_distribution.cdn.id],
            [".", "BytesDownloaded", ".", "."],
            [".", "4xxErrorRate", ".", "."],
            [".", "5xxErrorRate", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "CloudFront Performance Metrics"
        }
      }
    ]
  })
}