resource "aws_s3_bucket" "signedpkmap_certs_bucket" {
  bucket = "signedpkmap-certs"

  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_read_access_for_local_demo" {
  bucket = aws_s3_bucket.signedpkmap_certs_bucket.id
  policy = data.aws_iam_policy_document.allow_s3_read_access_for_local_demo_policy.json
}

data "aws_iam_policy_document" "allow_s3_read_access_for_local_demo_policy" {
  statement {
    sid = "AllowS3ReadAccess"

    principals {
      type        = "AWS"
      identifiers = [
        aws_iam_user.localdemo_user.arn,
        aws_iam_role.signedpkmap_lambda_role.arn
      ]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.signedpkmap_certs_bucket.arn,
      "${aws_s3_bucket.signedpkmap_certs_bucket.arn}/*",
    ]
  }
}
