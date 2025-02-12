const express = require('express');
const { cacheMiddleware } = require('../middlewares/CacheAPI');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({ message: `Welcome to FuckNime API 👋. Read documentation 📁: ${process.env.BASE_URL}/docs` });
});

// Anime Api
const List = require('../controllers/AnimeAPI/List');
router.get('/list', cacheMiddleware, List.index);

const Search = require('../controllers/AnimeAPI/Search');
router.get('/search', cacheMiddleware, Search.index);

const Alphabet = require('../controllers/AnimeAPI/Alphabet');
router.get('/alphabet', cacheMiddleware, Alphabet.index);

const Filter = require('../controllers/AnimeAPI/Filter');
router.get('/filter/advance', cacheMiddleware, Filter.index);
router.get('/filter/order', cacheMiddleware, Filter.Order);
router.get('/filter/type', cacheMiddleware, Filter.Type);
router.get('/filter/genre', cacheMiddleware, Filter.Genre);
router.get('/filter/status', cacheMiddleware, Filter.Status);
router.get('/filter/alphabet', cacheMiddleware, Filter.Alphabet);

const Detail = require('../controllers/AnimeAPI/Detail');
router.get('/detail/:slug', cacheMiddleware, Detail.index);

const Episode = require('../controllers/AnimeAPI/Episode');
router.get('/episode/:slug', cacheMiddleware, Episode.index);

// Komik Api
const KomikOrder = require('../controllers/KomikAPI/Order');
router.get('/komik/order', cacheMiddleware, KomikOrder.index);

const KomikType = require('../controllers/KomikAPI/Type');
router.get('/komik/type', cacheMiddleware, KomikType.index);

const KomikGenre = require('../controllers/KomikAPI/Genre');
router.get('/komik/genre', cacheMiddleware, KomikGenre.index);

const KomikStatus = require('../controllers/KomikAPI/Status');
router.get('/komik/status', cacheMiddleware, KomikStatus.index);

const KomikList = require('../controllers/KomikAPI/List');
router.get('/komik/list', cacheMiddleware, KomikList.index);

const KomikSearch = require('../controllers/KomikAPI/Search');
router.get('/komik/search', cacheMiddleware, KomikSearch.index);

const KomikDetail = require('../controllers/KomikAPI/Detail');
router.get('/komik/detail/:slug', cacheMiddleware, KomikDetail.index);

const KomikChapter = require('../controllers/KomikAPI/Chapter');
router.get('/komik/chapter/:slug', cacheMiddleware, KomikChapter.index);

module.exports = router;