# X509 Key Signer

A simple demo project that:
1. Reads an X509 certificate from AWS S3
2. Generates a RSA key pair, signs the certificate's public key
3. Stores CommonName + Signed public key into AWS Dynamo DB

## Tech stack:

- Terraform for infrastructure setup
- Node.js
