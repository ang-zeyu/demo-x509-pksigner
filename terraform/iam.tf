# For running locally
resource "aws_iam_user" "localdemo_user" {
  name = "localdemo"
}

resource "aws_iam_access_key" "localdemo_accesskey" {
  user    = aws_iam_user.localdemo_user.name
}

# Lambda
data "aws_iam_policy_document" "signedpkmap_lambda_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "signedpkmap_lambda_role" {
  name               = "signedpkmap_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.signedpkmap_lambda_role_policy.json
}
