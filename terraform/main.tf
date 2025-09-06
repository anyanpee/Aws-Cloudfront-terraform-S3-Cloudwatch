locals {
  static_files = {
    "index.html" = "text/html"
    "script.js"  = "application/javascript"
    "styles.css" = "text/css"
  }
}

resource "aws_s3_bucket" "site_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name = "StaticSiteBucket"
  }
}

resource "aws_s3_bucket_public_access_block" "block_all" {
  bucket = aws_s3_bucket.site_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.bucket_name}-oac"
  description                       = "OAC for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront automatically uses global edge locations
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html" #whats needs to be hit
  wait_for_deployment = true

  origin {
    domain_name = aws_s3_bucket.site_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.site_bucket.bucket

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.site_bucket.bucket
    compress = true

    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" # AWS Managed CachingOptimized policy
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id
  }

  # Optimized caching for static assets
  ordered_cache_behavior {
    path_pattern = "*.css"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.site_bucket.bucket
    compress = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # AWS Managed CachingOptimizedForUncompressedObjects
  }

  ordered_cache_behavior {
    path_pattern = "*.js"
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.site_bucket.bucket
    compress = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # AWS Managed CachingOptimizedForUncompressedObjects
  }

  # Using default CloudFront TLS cert; replace with ACM cert for custom domain (we dont have custom domain right now)
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" #block or allow some countries
    }
  }

  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }

  web_acl_id = aws_wafv2_web_acl.cloudfront_waf.arn

  tags = {
    Name = "StaticSiteCDN"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontAccessOnly",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.site_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_object" "website_assets" {
  for_each     = local.static_files
  bucket       = aws_s3_bucket.site_bucket.id
  key          = each.key
  source       = "../web/${each.key}"
  content_type = each.value
  etag         = filemd5("../web/${each.key}")
}