const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');
const { ProtocolFallback } = require('../../helpers/ProtocolHelper');

exports.index = async (req, res) => {
  try {
    const { show = 'A', page = 1 } = req.query;
	const url = `v1.animasu.top/daftar-anime/page/${page}/?show=${show}`;

    const data = await ProtocolFallback(url);
    const $ = cheerio.load(data);

    const results = [];

    $('.listo .bx').each((i, element) => {
      const title = $(element).find('.inx h2 a').text().trim();
      const slug = $(element).find('.inx h2 a').attr('href')?.replace(/^https?:\/\/v1\.animasu\.top\/anime\//, '').replace(/\/$/, '') || '#';
      const image = $(element).find('.imgx img').attr('src') || '';
      const genres = $(element).find('.inx span:contains("Genre:") a').map((i, el) => $(el).text().trim()).get() || "-";
      const releaseDate = $(element).find('.inx .split:contains("Rilis:")').text().replace('Rilis:', '').trim() || "-";
      const status = $(element).find('.inx span b:contains("Selesai")').text().trim() || 'Sedang Tayang';
      const type = $(element).find('.inx span:contains("Jenis:")').text().replace('Jenis:', '').trim() || "-";
      const author = $(element).find('.inx .split:contains("Pengarang:") a').text().trim() || "-";
      const studio = $(element).find('.inx span:contains("Studio:") a').text().trim() || "-";

      results.push({ title, slug, image, genres, releaseDate, status, type, author, studio });
    });

    const responseData = { success: true, data: results };

    setCache(res.cacheKey, responseData);
    res.json(responseData);

  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Gagal mengambil data' });
  }
};
