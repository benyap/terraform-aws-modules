#######################
# Configuration
#######################

resource "aws_route53_record" "route53-alias" {
  zone_id = "${var.record_zone_id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${var.cdn_domain_name}"
    zone_id                = "${var.cdn_zone_id}"
    evaluate_target_health = false
  }
}
