require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const http = require('http');
const path = require('path');
const ApiKeyMiddleware = require('./middlewares/AuthApiKey');
const { setupSocket } = require('./middlewares/Socket');

const app = express();
const server = http.createServer(app);

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.static(path.join(__dirname, 'public')));

app.use((req, res, next) => {
  req.domain = req.headers.host;
  next();
});

const Web = require('./routes/Web');
app.use('/', Web);

const Api = require('./routes/Api');
app.use('/v1', ApiKeyMiddleware, Api);

const NotFoundPage = require('./controllers/404Controller');
app.use((req, res, next) => {
    NotFoundPage.index(req, res);
});

setupSocket(server);

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});