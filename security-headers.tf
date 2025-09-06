# Security headers response policy for better security
resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "security-headers-policy"

  security_headers_config {
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains = true
      override = true
    }
    
    content_type_options {
      override = true
    }
    
    frame_options {
      frame_option = "DENY"
      override = true
    }
    
    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override = true
    }
  }
}