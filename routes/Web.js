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

const KomikPage = require('../controllers/KomikController');
router.get('/komik', KomikPage.index);

const KomikNewsPage = require('../controllers/KomikNewsController');
router.get('/komik/terbaru', KomikNewsPage.index);

const KomikUpdatePage = require('../controllers/KomikUpdateController');
router.get('/komik/terupdate', KomikUpdatePage.index);

const KomikRangkingPage = require('../controllers/KomikRangkingController');
router.get('/komik/peringkat', KomikRangkingPage.index);

const KomikRandomPage = require('../controllers/KomikRandomController');
router.get('/komik/acak', KomikRandomPage.index);

const KomikDetailPage = require('../controllers/KomikDetailController');
router.get('/komik/detail/:slug', KomikDetailPage.index);

const KomikChapterPage = require('../controllers/KomikChapterController');
router.get('/komik/chapter/:slug', KomikChapterPage.index);

const KomikSearchPage = require('../controllers/KomikSearchController');
router.get('/komik/pencarian', KomikSearchPage.index);

const KomikFilterPage = require('../controllers/KomikFilterController');
router.get('/komik/filter', KomikFilterPage.index);

module.exports = router;