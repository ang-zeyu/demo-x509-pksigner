import * as dotenv from 'dotenv';
dotenv.config();

import { signCertPublicKey } from './index.mjs';

const s3Key = process.argv[2];

if (s3Key) {
  console.log(`Signing ${s3Key}`);
  signCertPublicKey(s3Key);
} else {
  console.log('No key supplied');
}
