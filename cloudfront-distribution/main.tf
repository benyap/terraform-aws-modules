#######################
# Configuration
#######################

resource "aws_cloudfront_distribution" "domain-cdn" {
  count         = "${var.logging_enabled ? 0 : 1}"

  origin {
    origin_id   = "${var.origin_id}"
    domain_name = "${var.website_endpoint}"

    custom_origin_config {
      origin_protocol_policy  = "http-only"
      http_port               = "80"
      https_port              = "443"
      origin_ssl_protocols    = ["TLSv1"]
    }

    custom_header {
      name  = "User-Agent"
      value = "${var.duplicate_content_penalty_secret}"
    }
  }

  aliases       = "${var.domain_aliases}"
  enabled       = true
  price_class   = "PriceClass_All"
  http_version  = "http2"

  default_root_object = "${var.index_document}"

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "360"
    response_code         = "200"
    response_page_path    = "/${var.error_document}"
  }

  "default_cache_behavior" {
    allowed_methods = "${var.allowed_methods}"
    cached_methods  = ["GET", "HEAD"]

    "forwarded_values" {
      query_string  = "${var.forward_query_string}"

      cookies {
        forward     = "none"
      }
    }

    min_ttl          = "0"
    default_ttl      = "300"
    max_ttl          = "1200"
    target_origin_id = "${var.origin_id}"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  "restrictions" {
    "geo_restriction" {
      restriction_type = "none"
    }
  }

  "viewer_certificate" {
    acm_certificate_arn       = "${var.certificate_arn}"
    ssl_support_method        = "sni-only"
    minimum_protocol_version  = "TLSv1"
  }

  tags = "${merge("${var.tags}",
    map(
      "Name", "${var.project_tag}-${var.environment_tag}-${var.type_tag}",
      "Environment", "${var.environment_tag}",
      "Project", "${var.project_tag}"
    )
  )}"
}

resource "aws_cloudfront_distribution" "domain-cdn-with-logging" {
  count         = "${var.logging_enabled ? 1 : 0}"

  origin {
    origin_id   = "${var.origin_id}"
    domain_name = "${var.website_endpoint}"

    custom_origin_config {
      origin_protocol_policy  = "http-only"
      http_port               = "80"
      https_port              = "443"
      origin_ssl_protocols    = ["TLSv1"]
    }

    custom_header {
      name  = "User-Agent"
      value = "${var.duplicate_content_penalty_secret}"
    }
  }

  aliases       = "${var.domain_aliases}"
  enabled       = true
  price_class   = "PriceClass_All"
  http_version  = "http2"

  default_root_object = "${var.index_document}"

  logging_config {
    include_cookies = false
    bucket          = "${var.logging_bucket}"
    prefix          = "${var.logging_prefix}"
  }

  custom_error_response {
    error_code            = "404"
    error_caching_min_ttl = "360"
    response_code         = "200"
    response_page_path    = "/${var.error_document}"
  }

  "default_cache_behavior" {
    allowed_methods = "${var.allowed_methods}"
    cached_methods  = ["GET", "HEAD"]

    "forwarded_values" {
      query_string  = "${var.forward_query_string}"

      cookies {
        forward     = "none"
      }
    }

    min_ttl          = "0"
    default_ttl      = "300"
    max_ttl          = "1200"
    target_origin_id = "${var.origin_id}"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  "restrictions" {
    "geo_restriction" {
      restriction_type = "none"
    }
  }

  "viewer_certificate" {
    acm_certificate_arn       = "${var.certificate_arn}"
    ssl_support_method        = "sni-only"
    minimum_protocol_version  = "TLSv1"
  }

  tags = "${merge("${var.tags}",
    map(
      "Name", "${var.project_tag}-${var.environment_tag}-${var.type_tag}",
      "Environment", "${var.environment_tag}",
      "Project", "${var.project_tag}"
    )
  )}"
}
