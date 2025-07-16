const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');
const { ProtocolFallback } = require('../../helpers/ProtocolHelper');

exports.index = async (req, res) => {
  const { type = '', order = '', genre = '', genre2 = '',status = '', page = 1 } = req.query;
  
  try {
    const url = `api.komiku.org/manga/page/${page}/?orderby=${order}&tipe=${type}&genre=${genre}&genre2=${genre2}&status=${status}`;
	const html = await ProtocolFallback(url);
    const $ = cheerio.load(html);
	
	const list = [];
    $('.bge').each((i, element) => {
      const slug = $(element).find('.bgei a').attr('href')?.replace(/^https:\/\/komiku\.org\/manga\//, '').replace(/\/$/, '') || '#';
      const image = $(element).find('.bgei img').attr('src');
      const type = $(element).find('.tpe1_inf b').text().trim();
      const genre = $(element).find('.tpe1_inf').text().replace(type, '').trim();
      const title = $(element).find('.kan h3').text().trim();
      const info = $(element).find('.kan .judul2').text().trim();
      const synopsis = $(element).find('.kan p').text().trim();
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
