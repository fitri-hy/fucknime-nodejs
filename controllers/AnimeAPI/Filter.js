const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');
const { ProtocolFallback } = require('../../helpers/ProtocolHelper');

exports.index = async (req, res) => {
  try {
    const { genre = "aksi", status = "", type = "", order = 'default', page = 1 } = req.query;
    const url = `v1.animasu.top/pencarian/?genre%5B0%5D=${genre}&status=${status}&tipe=${type}&urutan=${order}&halaman=${page}`;

    const data = await ProtocolFallback(url);
    const $ = cheerio.load(data);

    const results = [];

    $('.listupd .bsx').each((i, element) => {
      const title = $(element).find('.tt').text().trim();
      const slug = $(element).find('a').attr('href')?.replace(/^https:\/\/v9\.animasu\.cc\/anime\//, '').replace(/\/$/, '') || '#';

      const image = $(element).find('img').attr('src') || '';
      const episodes = $(element).find('.bt .epx').text().trim();
      const status = $(element).find('.bt .sb').text().trim();
      const type = $(element).find('.typez').text().trim();

      results.push({ title, slug, image, episodes, status, type });
    });

    const responseData = { success: true, data: results };

    setCache(res.cacheKey, responseData);
    res.json(responseData);

  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Gagal mengambil data' });
  }
};

exports.Order = async (req, res) => {
  try {

    const data = [
      { slug: "default", title: "Standar" },
      { slug: "abjad", title: "Judul A-Z" },
      { slug: "dari-z", title: "Judul Z-A" },
      { slug: "update", title: "Baru Diupdate" },
      { slug: "publikasi", title: "Baru Ditambah" },
      { slug: "populer", title: "Terpopuler" },
      { slug: "baru", title: "Rilis Terbaru" },
      { slug: "lama", title: "Rilis Terlawas" },
      { slug: "rating", title: "Peringkat" }
    ];
	
    const responseData = { success: true, data };

    setCache(res.cacheKey, responseData);
    res.json(responseData);
	
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Gagal mengambil data' });
  }
};

exports.Type = async (req, res) => {
  try {

    const data = [
      { slug: "", title: "Semua" },
      { slug: "TV", title: "TV" },
      { slug: "Movie", title: "Movie" },
      { slug: "OVA", title: "OVA" },
      { slug: "ONA", title: "ONA" },
      { slug: "Special", title: "Special" },
      { slug: "Music", title: "Music" }
    ];
	
    const responseData = { success: true, data };

    setCache(res.cacheKey, responseData);
    res.json(responseData);
	
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Gagal mengambil data' });
  }
};

exports.Genre = async (req, res) => {
  try {
    const data = [
      { slug: "aksi", title: "Aksi" },
      { slug: "anak-anak", title: "Anak-Anak" },
      { slug: "luar-angkasa", title: "Antariksa" },
      { slug: "avant-garde", title: "Avant Garde" },
      { slug: "dementia", title: "Dimensia" },
      { slug: "donghua", title: "Donghua" },
      { slug: "drama", title: "Drama" },
      { slug: "ecchi", title: "Ecchi" },
      { slug: "fantasi", title: "Fantasi" },
      { slug: "fantasi-urban", title: "Fantasi Urban" },
      { slug: "game", title: "Game" },
      { slug: "gourmet", title: "Gourmet" },
      { slug: "harem", title: "Harem" },
      { slug: "horror", title: "Horror" },
      { slug: "iblis", title: "Iblis" },
      { slug: "isekai", title: "Isekai" },
      { slug: "josei", title: "Josei" },
      { slug: "suspense", title: "Ketegangan" },
      { slug: "komedi", title: "Komedi" },
      { slug: "live-action", title: "Live Action" },
      { slug: "makanan", title: "Makanan" },
      { slug: "martial-arts", title: "Martial Arts" },
      { slug: "medical", title: "Medis" },
      { slug: "militer", title: "Militer" },
      { slug: "misteri", title: "Misteri" },
      { slug: "mobil", title: "Mobil" },
      { slug: "musik", title: "Musik" },
      { slug: "olahraga", title: "Olahraga" },
      { slug: "parodi", title: "Parodi" },
      { slug: "perang", title: "Perang" },
      { slug: "petualangan", title: "Petualangan" },
      { slug: "polisi", title: "Polisi" },
      { slug: "psikologis", title: "Psikologis" },
      { slug: "reincarnation", title: "Reinkarnasi" },
      { slug: "mecha", title: "Robot" },
      { slug: "romansa", title: "Romansa" },
      { slug: "samurai", title: "Samurai" },
      { slug: "sci-fi", title: "Sci-Fi" },
      { slug: "seinen", title: "Seinen" },
      { slug: "sejarah", title: "Sejarah" },
      { slug: "sekolahan", title: "Sekolahan" },
      { slug: "shoujo", title: "Shoujo" },
      { slug: "shoujo-ai", title: "Shoujo Ai" },
      { slug: "shounen", title: "Shounen" },
      { slug: "shounen-ai", title: "Shounen Ai" },
      { slug: "sihir", title: "Sihir" },
      { slug: "slice-of-life", title: "Slice of Life" },
      { slug: "super-power", title: "Super Power" },
      { slug: "supranatural", title: "Supranatural" },
      { slug: "thriller", title: "Thriller" },
      { slug: "time-travel", title: "Time Travel" },
      { slug: "vampir", title: "Vampir" },
      { slug: "yaoi", title: "Yaoi" }
    ];

    const responseData = { success: true, data };

    setCache(res.cacheKey, responseData);
    res.json(responseData);

  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Gagal mengambil data' });
  }
};

exports.Status = async (req, res) => {
  try {

    const data = [
      { slug: "", title: "Semua" },
      { slug: "upcoming", title: "Segera Tayang" },
      { slug: "ongoing", title: "Sedang Tayang" },
      { slug: "completed", title: "Selesai Tayang" }
    ];
	
    const responseData = { success: true, data };

    setCache(res.cacheKey, responseData);
    res.json(responseData);
	
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Gagal mengambil data' });
  }
};

exports.Alphabet = async (req, res) => {
  try {
    const data = Array.from({ length: 26 }, (_, i) => {
      const letter = String.fromCharCode(65 + i);
      return { slug: letter, title: letter };
    });

    const responseData = { success: true, data };

    setCache(res.cacheKey, responseData);
    res.json(responseData);
	
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Gagal mengambil data' });
  }
};
