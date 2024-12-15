import { X509Certificate } from 'crypto';
import crypto from 'crypto';
import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { DynamoDBClient, PutItemCommand } from "@aws-sdk/client-dynamodb"; // ES Modules import

const client = new S3Client({ region: process.env.AWS_REGION });
const dynamoDBClient = new DynamoDBClient({ region: process.env.AWS_REGION })

export async function signCertPublicKey(s3Key) {
  const getCertCommand = new GetObjectCommand({
    Bucket: process.env.AWS_CERT_BUCKET,
    Key: s3Key,
  });

  const certResult = await client.send(getCertCommand);
  const certResultBytes = await certResult.Body.transformToByteArray();

  const cert = new X509Certificate(certResultBytes);
  const commonName = cert.subject
    .split('\n')
    .find(line => line.startsWith('CN='))
    ?.substring('CN='.length);
  const publicKey = cert.publicKey.export({ type: 'pkcs1', format: 'pem' });

  if (!commonName) {
    throw new Error('Could not find CommonName');
  }

  console.log(`Common name: ${commonName}`);
  console.log('Public key: ', publicKey, typeof publicKey, publicKey.length);

  const keyPair = crypto.generateKeyPairSync('rsa', { modulusLength: 2048 });
  const signedPK = crypto.sign(null, publicKey, keyPair.privateKey);

  const storeSignedPKCommand = new PutItemCommand({
    TableName: process.env.AWS_DYNAMO_DB_TABLE,
    Item: {
      "CommonName": {
        "S": commonName,
      },
      "PublicKey": {
        "B": signedPK,
      }
    }
  })

  await dynamoDBClient.send(storeSignedPKCommand);

  console.log('success, verifying...');

  const verificationResult = crypto.verify(null, publicKey, keyPair.publicKey, signedPK);

  console.log(`Verified: ${verificationResult}`);

  return `Success, processed ${s3Key}`;
};

export const handler = async (event) => {
  await signCertPublicKey(event.s3Key);
};
