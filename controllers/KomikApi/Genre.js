const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');

exports.index = async (req, res) => {
  try {
    const response = await axios.get('https://komiku.id/pustaka/');
    const html = response.data;
    const $ = cheerio.load(html);

    const order = [];
    $('select[name="genre"] option').each((i, element) => {
      const title = $(element).text().trim();
      const slug = $(element).attr('value').trim() || '';

      order.push({ title, slug });
    });

    if (order.length > 0) {
      order[0].title = 'Tidak Ada';
    }

    const responseData = { success: true, data: order };
    setCache(res.cacheKey, responseData);
    res.json(responseData);
  } catch (error) {
    console.error('Error:', error.message);
    res.status(500).json({ success: false, message: 'Failed to load order.' });
  }
};
