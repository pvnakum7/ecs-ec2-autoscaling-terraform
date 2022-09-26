
#### Temporaty Manually Added Certificate ARN -Start


resource "aws_lb_listener_certificate" "beta_domain" {
  listener_arn    = aws_lb_listener.https_listeners.arn
  certificate_arn = "arn:aws:acm:us-east-1:918135752127:certificate/de05b649-d774-489c-a3e1-fbdab2bbd7ca"
}

# Additional certificate for the .org
resource "aws_lb_listener_certificate" "api_beta_domain" {
  listener_arn    = aws_lb_listener.https_listeners.arn
  certificate_arn = "arn:aws:acm:us-east-1:918135752127:certificate/b9d58c82-dc79-4f30-9311-03e9bd48309e"
}

#### Temporaty Manually Added Certificate ARN -end