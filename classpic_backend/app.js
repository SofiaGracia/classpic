import express from 'express';
import https from 'https';
import fs from 'fs';

// Carregar els certificats i crea un JSON anomenat credentials
const privateKey = fs.readFileSync('./certs/server.key', 'utf8');
const certificate = fs.readFileSync('./certs/server.cert', 'utf8');
const credentials = { key: privateKey, cert: certificate };

// Definim app com a una aplicació Express
const app = express();

// Incorporem el middleware per gestionar sol·licituds JSON
app.use(express.json());

// Creem una ruta de prova
app.get('/', (req, res) => {
  res.send('Connexió segura establerta amb HTTPS!');
});

// Creem el servidor HTTPS amb les credencials i l'aplicació Express
const httpsServer = https.createServer(credentials, app);

// Escoltar al port 3000
httpsServer.listen(3000, () => {
  console.log('Servidor HTTPS en execució a https://localhost:3000');
});