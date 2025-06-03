resource "aws_s3_bucket" "redirect_website" {
    bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "redirect_website" {
    bucket = aws_s3_bucket.redirect_website.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "redirect_website" {
    bucket = aws_s3_bucket.redirect_website.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid = "PublicReadGetObject"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.redirect_website.arn}/*"
            }
        ]
    })
    depends_on = [ aws_s3_bucket_public_access_block.redirect_website ]
}

resource "aws_s3_bucket_website_configuration" "redirect_website" {
    bucket = aws_s3_bucket.redirect_website.id

    index_document {
      suffix = "index.html"
    }

    error_document {
      key = "error.html"
    }
}

resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.redirect_website.id
    key = "index.html"
    content = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Przekierowanie</title>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="5; url=http://${aws_lb.web.dns_name}" />
</head>
<body>
    <h1>Przekierowanie do aplikacji</h1>
    <p>Za 5 sekund zostaniesz przekierowany do aplikacji.</p>
    <p>Jeśli przekierowanie nie działa, <a href="http://${aws_lb.web.dns_name}">kliknij tutaj</a>.</p>
</body>
</html>
EOF
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
    bucket = aws_s3_bucket.redirect_website.id
    key = "error.html"
    content = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Błąd</title>
    <meta charset="UTF-8">
</head>
<body>
    <h1>Błąd</h1>
    <p>Nie znaleziono żądanej strony.</p>
    <p><a href="index.html">Wróć do strony głównej</a></p>
</body>
</html>
EOF
  content_type = "text/html"
}