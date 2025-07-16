const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');
const { ProtocolFallback } = require('../../helpers/ProtocolHelper');

exports.index = async (req, res) => {
    const { q = '', page = 1 } = req.query;
  
  try {
	const url = `komiku.org/page/${page}/?post_type=manga&s=${q}`;
    const html = await ProtocolFallback(url);
    const $ = cheerio.load(html);
	
	const list = [];
    $('.bge').each((i, element) => {
      const slug = $(element).find('.bgei a').attr('href')?.replace(/^\/manga\//, '').replace(/\/$/, '') || '#';
      const image = $(element).find('.bgei img').attr('src');
      const type = $(element).find('.tpe1_inf b').text().trim();
      const genre = $(element).find('.tpe1_inf').text().replace(type, '').trim();
      const title = $(element).find('.kan h3').text().trim();
	  const info = $(element).find('.kan p').text().trim().match(/^(Update .*?\.)\s*(.*)$/) ? $(element).find('.kan p').text().trim().match(/^(Update .*?\.)\s*(.*)$/)[1] : '';
	  const synopsis = $(element).find('.kan p').text().trim().match(/^(Update .*?\.)\s*(.*)$/) ? $(element).find('.kan p').text().trim().match(/^(Update .*?\.)\s*(.*)$/)[2] : $(element).find('.kan p').text().trim();
      const firstChapter = $(element).find('.new1:first a span:last').text().trim();
      const latestChapter = $(element).find('.new1:last a span:last').text().trim();

      list.push({
        title,
        slug,
        image,
        type,
        genre,
        info,
        synopsis,
        firstChapter,
        latestChapter
      });
    });

    const responseData = { success: true, data: list };
    setCache(res.cacheKey, responseData);
    res.json(responseData);
  } catch (error) {
    console.error('Error:', error.message);
    res.status(500).json({ success: false, message: 'Failed to load data.' });
  }
};
