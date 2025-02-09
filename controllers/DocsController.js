const fs = require('fs');
const path = require('path');
const { marked } = require('marked');

exports.index = (req, res) => {
    const docsPath = path.join(__dirname, '../database/docs.json');
    const docsData = JSON.parse(fs.readFileSync(docsPath, 'utf-8'));

    const data = marked(docsData.content);
    
    res.render('docs', { 
        site_title: docsData.title,
        site_desc: 'Panduan lengkap penggunaan API untuk mendapatkan data anime, karakter, dan episode.',
		site_keyword: 'API anime, dokumentasi API, data anime, API karakter anime, API episode anime',
        site_url: req.domain,
        docs: data
    });
};
