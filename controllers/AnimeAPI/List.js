const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');
const { ProtocolFallback } = require('../../helpers/ProtocolHelper');

exports.index = async (req, res) => {
  try {
    const { order = 'default', page = 1 } = req.query;
    const url = `v1.animasu.top/pencarian/?urutan=${order}&halaman=${page}`;

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
