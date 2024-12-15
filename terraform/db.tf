resource "aws_dynamodb_table" "signedpkmap_certs_table" {
  name           = "signedpkmap_certs_table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "CommonName"

  attribute {
    name = "CommonName"
    type = "S"
  }
}

resource "aws_iam_user_policy" "allow_db_write_access_for_local_demo_policy" {
  name        = "allow_db_write_access_for_local_demo"
  user = aws_iam_user.localdemo_user.name

  policy = data.aws_iam_policy_document.allow_db_write_access_for_local_demo_policy.json
}

resource "aws_iam_role_policy" "allow_db_write_access_for_lambda_policy" {
  name        = "allow_db_write_access_for_lambda_policy"
  role       = aws_iam_role.signedpkmap_lambda_role.name

  policy = data.aws_iam_policy_document.allow_db_write_access_for_local_demo_policy.json
}

data "aws_iam_policy_document" "allow_db_write_access_for_local_demo_policy" {
  statement {
    sid = "AllowDBWriteAccess"

    actions = [
      # "dynamodb:ConditionCheckItem",
      "dynamodb:PutItem"
      # "dynamodb:DescribeTable",
      # "dynamodb:DeleteItem",
      # "dynamodb:GetItem",
      # "dynamodb:Scan",
      # "dynamodb:Query"
      # "dynamodb:UpdateItem"
    ]

    resources = [
      aws_dynamodb_table.signedpkmap_certs_table.arn
    ]
  }
}
