const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');

exports.index = async (req, res) => {
  try {
    const { slug } = req.params;
    const url = `https://v9.animasu.cc/anime/${slug}`;

    const { data } = await axios.get(url);
    const $ = cheerio.load(data);

    const title = $('.infox h1[itemprop="headline"]').text().trim();
    const imageUrl = `https:${$('.thumb img').attr('src')}`;
    const description = $('.sepele').text().trim().replace(/Animasu/gi, 'FuckNime') || "-";
    const status = $('.spe span:contains("Status:") font').text().trim() || "-";
    const releaseDate = $('.spe span.split:contains("Rilis:")').text().replace('Rilis:', '').trim() || "-";
    const type = $('.spe span:contains("Jenis")').text().replace('Jenis:', '').trim() || "-";
    const episodes = $('.spe span:contains("Episode:")').text().replace('Episode:', '').trim() || "-";
    const duration = $('.spe span:contains("Durasi:")').text().replace('Durasi:', '').trim() || "-";
    const author = $('.spe span:contains("Pengarang:") a').text().trim() || "-";
    const studio = $('.spe span:contains("Studio:") a').text().trim() || "-";
    const season = $('.spe span:contains("Season:")').text().replace('Season:', '').trim() || "-";
    const updatedAt = $('.spe span.split:contains("Diupdate:") time').text().trim() || "-";

    const genres = [];
    $('.spe span:contains("Genre") a').each((i, el) => {
      genres.push($(el).text().trim());
    });
	
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
      imageUrl,
      description,
      status,
      releaseDate,
      type,
      episodes,
      duration,
      author,
      studio,
      season,
      updatedAt,
      genres: genres.join(', '),
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
