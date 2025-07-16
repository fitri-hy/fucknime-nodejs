const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');
const { ProtocolFallback } = require('../../helpers/ProtocolHelper');

exports.index = async (req, res) => {
  const { slug } = req.params;

  if (!slug) {
    return res.status(400).json({ success: false, message: 'Parameter slug diperlukan' });
  }

  try {
    const url = `komiku.org/${slug}`;
    const html = await ProtocolFallback(url);
    const $ = cheerio.load(html);

    const info = {};

    $('tbody[data-test="informasi"] tr').each((index, element) => {
      const key = $(element).find('td').eq(0).text().trim();
      const value = $(element).find('td').eq(1).text().trim();
      if (key && value) {
        info[key] = value;
      }
    });

    const results = [];

    $('#Baca_Komik img').each((index, element) => {
      const imgSrc = $(element).attr('src');
      const altText = $(element).attr('alt');

      results.push({ img: imgSrc, alt: altText });
    });

    const responseData = { 
      success: true, 
      title: info['Judul'] || 'Tidak Diketahui',
      data: results
    };

    setCache(res.cacheKey, responseData);
    res.json(responseData);
  } catch (error) {
    console.error('Error fetching data:', error.message);
    res.status(500).json({ success: false, message: 'Gagal mengambil data dari sumber' });
  }
};
