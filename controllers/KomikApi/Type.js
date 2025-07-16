const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');
const { ProtocolFallback } = require('../../helpers/ProtocolHelper');

exports.index = async (req, res) => {
  try {
	const url = `komiku.org/pustaka/`;
    const html = await ProtocolFallback(url);
    const $ = cheerio.load(html);

    const type = [];
    $('select[name="tipe"] option').each((i, element) => {
      const title = $(element).text().trim();
      const slug = $(element).attr('value').trim() || '';

      type.push({ title, slug });
    });

    if (type.length > 0) {
      type[0].title = 'Tidak Ada';
    }

    const responseData = { success: true, data: type };
    setCache(res.cacheKey, responseData);
    res.json(responseData);
  } catch (error) {
    console.error('Error:', error.message);
    res.status(500).json({ success: false, message: 'Failed to load type.' });
  }
};
