const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');

exports.index = async (req, res) => {
  try {
    const { slug } = req.params;
    const url = `https://v9.animasu.cc/${slug}`;

    const { data } = await axios.get(url);
    const $ = cheerio.load(data);

    const title = $('h1[itemprop="name"]').text().trim();
    const description = $('div.bixbox.infx[itemprop="mainContentOfPage"]').text().trim().replace(/Animasu/gi, 'FuckNime') || "-";;
	const videoEmbedUrl = $('div.player-embed iframe').attr('src');
	const prevEpisode = $('div.nvs a[rel="prev"]').attr('href').replace(/^https:\/\/v9\.animasu\.cc\//, '').replace(/\/$/, '') || null;
	const nextEpisode = $('div.nvs a[rel="next"]').attr('href').replace(/^https:\/\/v9\.animasu\.cc\//, '').replace(/\/$/, '') || null;
	
	const episodesList = $('#daftarepisode li')
      .map((i, el) => {
        const episodeTitle = $(el).find('a').first().text().trim();
        const episodeUrl = $(el).find('a').first().attr('href').replace(/^https:\/\/v9\.animasu\.cc\//, '').replace(/\/$/, '').trim() || "";

        return {
          title: episodeTitle,
          slug: episodeUrl
        };
      })
      .get();

    const results = {
      title,
	  description,
	  videoEmbedUrl,
	  prevEpisode,
	  nextEpisode,
	  episodesList
    };

    const responseData = { success: true, data: results };

    setCache(res.cacheKey, responseData);
    res.json(responseData);

  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Gagal mengambil data' });
  }
};
