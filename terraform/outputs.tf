output "access_key_id" {
  value = aws_iam_access_key.localdemo_accesskey.id
}

output "access_key_secret" {
  value = aws_iam_access_key.localdemo_accesskey.secret
  sensitive = true
}
