

data "archive_file" "signpk_lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/../index.mjs"
  output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "signpk_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "signpk"
  role          = aws_iam_role.signedpkmap_lambda_role.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.signpk_lambda_archive.output_base64sha256

  runtime = "nodejs20.x"

  environment {
    variables = {
      AWS_CERT_BUCKET = aws_s3_bucket.signedpkmap_certs_bucket.id
      AWS_DYNAMO_DB_TABLE = aws_dynamodb_table.signedpkmap_certs_table.id
    }
  }
}
