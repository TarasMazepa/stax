import express from 'express';
import cors from 'cors';
import axios from 'axios';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, resolve } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const envPath = resolve(__dirname, '../.env');

dotenv.config({ path: envPath });

console.log('Environment loaded from:', envPath);
console.log('GITHUB_CLIENT_SECRET exists:', !!process.env.GITHUB_CLIENT_SECRET);
console.log('client_secret', process.env.GITHUB_CLIENT_SECRET);

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.post('/token', async (req, res) => {
  try {
    const { code, client_id, redirect_uri } = req.body;
    const client_secret = process.env.GITHUB_CLIENT_SECRET;
    // Exchange the code for an access token with GitHub
    console.log('client_secret', client_secret);
    console.log('client_id', client_id);
    console.log('code', code);
    console.log('redirect_uri', redirect_uri);
    const response = await axios.post('https://github.com/login/oauth/access_token', {
      client_id,
      client_secret,
      code,
      redirect_uri
    }, {
      headers: {
        'Accept': 'application/json'
      }
    });

    res.json(response.data);
  } catch (error) {
    console.error('Token exchange error:', error);
    res.status(500).json({ error: 'Failed to exchange code for token' });
  }
});

app.listen(PORT, () => {
  console.log(`Proxy server running on port ${PORT}`);
}); 