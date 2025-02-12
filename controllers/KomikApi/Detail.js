const axios = require('axios');
const cheerio = require('cheerio');
const { setCache } = require('../../middlewares/CacheAPI');

exports.index = async (req, res) => {
  const { slug } = req.params;

  if (!slug) {
    return res.status(400).json({ success: false, message: 'Parameter slug diperlukan' });
  }

  try {
    const response = await axios.get(`https://komiku.id/manga/${slug}`);
    const html = response.data;
    const $ = cheerio.load(html);

    const title = $('h1 span[itemprop="name"]').text().trim();
    const image = $('img[itemprop="image"]').attr('src');
    const description = $('p[itemprop="description"]').text().trim();
    const oldChapter = $('.new1.sd.rd').first().find('a').text().trim().replace('Awal:', '').trim();
    const oldChapterLink = $('.new1.sd.rd').first().find('a').attr('href')?.replace(/^\//, '').replace(/\/$/, '') || '#';
    const latestChapter = $('.new1.sd.rd').last().find('a').text().trim().replace('Terbaru:', '').trim();
    const latestChapterLink = $('.new1.sd.rd').last().find('a').attr('href')?.replace(/^\//, '').replace(/\/$/, '') || '#';

    const infoTable = $('.inftable tbody tr');
    const genres = [];

    $('.genre a span[itemprop="genre"]').each((i, el) => {
      genres.push($(el).text().trim());
    });

    const infoMap = {
      "Judul Komik": "title",
      "Judul Indonesia": "title_id",
      "Jenis Komik": "type",
      "Konsep Cerita": "story",
      "Pengarang": "author",
      "Status": "status",
      "Umur Pembaca": "age",
      "Cara Baca": "read"
    };

    const info = {};
    infoTable.each((i, row) => {
      const key = $(row).find('td').first().text().trim();
      const value = $(row).find('td').last().text().trim();
      if (infoMap[key]) {
        info[infoMap[key]] = value;
      }
    });

    const chapters = [];
    $('#daftarChapter tr').each((i, row) => {
      if (i === 0) return;
      const chapterNumber = $(row).find('.judulseries a span').text().trim();
      const chapterLink = $(row).find('.judulseries a').attr('href').replace(/^\//, '').replace(/\/$/, '') || '#';
      const views = $(row).find('.pembaca i').text().trim();
      const date = $(row).find('.tanggalseries').text().trim();

      if (chapterNumber && chapterLink) {
        chapters.push({
          title: chapterNumber,
          slug: chapterLink,
          views,
          date
        });
      }
    });

    const results = {
      title,
      image,
      description,
      oldChapter,
      oldChapterLink,
      latestChapter,
      latestChapterLink,
      ...info,
      genres,
      chapters
    };

    const responseData = { success: true, data: results };

    setCache(res.cacheKey, responseData);
    res.json(responseData);
  } catch (error) {
    console.error('Error fetching data:', error.message);
    res.status(500).json({ success: false, message: 'Gagal mengambil data dari sumber' });
  }
};
