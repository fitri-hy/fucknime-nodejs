const express = require('express');
const { cacheMiddleware } = require('../middlewares/CacheAPI');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({ message: `Welcome to FuckNime API 👋. Read documentation 📁: ${process.env.BASE_URL}/docs` });
});

const List = require('../controllers/api/List');
router.get('/list', cacheMiddleware, List.index);

const Search = require('../controllers/api/Search');
router.get('/search', cacheMiddleware, Search.index);

const Alphabet = require('../controllers/api/Alphabet');
router.get('/alphabet', cacheMiddleware, Alphabet.index);

const Filter = require('../controllers/api/Filter');
router.get('/filter/advance', cacheMiddleware, Filter.index);
router.get('/filter/order', cacheMiddleware, Filter.Order);
router.get('/filter/type', cacheMiddleware, Filter.Type);
router.get('/filter/genre', cacheMiddleware, Filter.Genre);
router.get('/filter/status', cacheMiddleware, Filter.Status);
router.get('/filter/alphabet', cacheMiddleware, Filter.Alphabet);

const Detail = require('../controllers/api/Detail');
router.get('/detail/:slug', cacheMiddleware, Detail.index);

const Episode = require('../controllers/api/Episode');
router.get('/episode/:slug', cacheMiddleware, Episode.index);

module.exports = router;