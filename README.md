# CloudFront + Terraform + S3 Demo
## Faster Application Response Time with Global CDN

This project demonstrates how to set up a high-performance static website using AWS CloudFront, Terraform, and S3 to achieve faster application response times through global content delivery.

## 🏗️ Architecture

- **S3**: Static website hosting with secure bucket configuration
- **CloudFront**: Global CDN with edge locations for faster content delivery
- **WAF**: Web Application Firewall for security protection
- **Terraform**: Infrastructure as Code for automated deployment

## Architecture Diagram
![](<diagrame f0r clondfront Screenshot 2025-09-06 051004.png>)

## 🚀 Features

- ✅ Global edge caching with CloudFront
- ✅ Gzip compression for optimized delivery
- ✅ Security headers (HSTS, X-Frame-Options, etc.)
- ✅ WAF protection with bot control and rate limiting
- ✅ HTTPS redirect enforcement
- ✅ Custom error pages
- ✅ CloudWatch monitoring

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.3.0 installed
- VS Code or preferred IDE

## 🛠️ Setup Process

### 1. VS Code Setup
![VS Code Setup](screenshots/vs.code.setup-Screenshot%202025-09-06%20023702.png)

### 2. Initialize Terraform
```bash
terraform init
```
![Terraform Init](screenshots/terraform-init-Screenshot%202025-09-06%20023919.png)

### 3. Plan Infrastructure
```bash
terraform plan
```
![Terraform Plan](screenshots/teerraform-plan-Screenshot%202025-09-06%20024407.png)

### 4. Import Existing S3 Bucket (if needed)
```bash
terraform import aws_s3_bucket.site_bucket bucket-name
```
![Terraform Import](screenshots/terraform-import-Screenshot%202025-09-06%20024742.png)

### 5. Deploy Infrastructure
```bash
terraform apply
```

## 📸 AWS Console Verification

### S3 Bucket Configuration
![S3 Bucket](screenshots/S3-BUCKET-Screenshot%202025-09-06%20032454.png)

### CloudFront Distribution
![CloudFront Console](screenshots/cloudfront-on-aws-console-Screenshot%202025-09-06%20031802.png)

### WAF Configuration
![WAF Setup](screenshots/cloudfront-Waf-Screenshot%202025-09-06%20032306.png)


## 🌐 Final Result

### Live Application
![CloudFront Application](screenshots/cloudfront-frontpage-main-Screenshot%202025-09-06%20031443.png)


## 📁 Project Structure

```
cloud front/
├── main.tf                 # Main CloudFront and S3 configuration
├── waf.tf                  # WAF security rules
├── security-headers.tf     # Security headers policy
├── cloudwatch.tf          # Monitoring and dashboard
├── provider.tf             # AWS provider configuration
├── variable.tf             # Input variables
├── output.tf               # Output values
├── index.html              # Main webpage
├── styles.css              # Styling
├── script.js               # JavaScript functionality
└── README.md               # This file
```

## 🔧 Configuration Details

### CloudFront Features
- **Compression**: Enabled for all content types
- **Cache Policies**: AWS managed policies for optimal performance
- **Security**: Response headers policy with HSTS, X-Frame-Options
- **Error Handling**: Custom 404/403 error pages

### WAF Protection
- **Bot Control**: AWS managed bot control rules
- **IP Reputation**: Blocks known malicious IPs
- **Rate Limiting**: 10,000 requests per IP limit
- **Anonymous IP**: Blocks anonymous proxy traffic

### S3 Configuration
- **Public Access**: Blocked (CloudFront access only)
- **Origin Access Control**: Secure S3 access
- **Force Destroy**: Enabled for easy cleanup

## 📊 Performance Benefits

- **Global Reach**: 400+ CloudFront edge locations worldwide
- **Faster Load Times**: Content served from nearest edge location
- **Reduced Origin Load**: S3 requests minimized through caching
- **Security**: WAF protection against common attacks
- **Monitoring**: CloudWatch metrics and dashboards


## 🎯 Use Cases

This setup is ideal for:
- Static websites requiring global performance
- Single Page Applications (SPAs)
- Marketing landing pages
- Documentation sites
- Portfolio websites

## 🔒 Security Features

- HTTPS enforcement
- Security headers implementation
- WAF protection against OWASP Top 10
- S3 bucket security best practices
- Origin Access Control (OAC)

---

**Built with ❤️ using AWS CloudFront, Terraform, and S3**