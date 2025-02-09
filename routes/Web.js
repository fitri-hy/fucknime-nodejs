const express = require('express');
const router = express.Router();

const HomePage = require('../controllers/HomeController');
router.get('/', HomePage.index);

const NewsPage = require('../controllers/NewsController');
router.get('/terbaru', NewsPage.index);

const PopularPage = require('../controllers/PopularController');
router.get('/populer', PopularPage.index);

const OldPage = require('../controllers/OldController');
router.get('/terlama', OldPage.index);

const RangkingPage = require('../controllers/RangkingController');
router.get('/peringkat', RangkingPage.index);

const SearchPage = require('../controllers/SearchController');
router.get('/pencarian', SearchPage.index);

const FilterPage = require('../controllers/FilterController');
router.get('/filter', FilterPage.index);

const DetailPage = require('../controllers/DetailController');
router.get('/anime/:slug', DetailPage.index);

const EpisodePage = require('../controllers/EpisodeController');
router.get('/episode/:slug', EpisodePage.index);

const Alphabet = require('../controllers/AlphabetController');
router.get('/alphabet', Alphabet.index);

const DocsPage = require('../controllers/DocsController');
router.get('/docs', DocsPage.index);

module.exports = router;