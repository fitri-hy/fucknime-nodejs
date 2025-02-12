const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');

exports.index = async (req, res) => {
  try {
    const response = await axios.get('https://komiku.id/pustaka/');
    const html = response.data;
    const $ = cheerio.load(html);

    const status = [];
    $('select[name="status"] option').each((i, element) => {
      const title = $(element).text().trim();
      const slug = $(element).attr('value').trim() || '';

      status.push({ title, slug });
    });

    if (status.length > 0) {
      status[0].title = 'Tidak Ada';
    }

    const responseData = { success: true, data: status };
    setCache(res.cacheKey, responseData);
    res.json(responseData);
  } catch (error) {
    console.error('Error:', error.message);
    res.status(500).json({ success: false, message: 'Failed to load status.' });
  }
};
