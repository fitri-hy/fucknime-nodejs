const axios = require('axios');
require('dotenv').config();

exports.index = async (req, res) => {
    try {
        const page = Number(req.query.page) || 1;
        const apiUrl = `${process.env.BASE_URL}/v1/komik/list?order=modified&page=${page}`;

        const response = await axios.get(apiUrl, {
            headers: { 'x-api-key': process.env.API_KEY }
        });

        const { data } = response.data;
        const nextPage = page + 1;
        const prevPage = page > 1 ? page - 1 : null;

        res.render('komik-update', { 
            site_title: 'Terupdate | Komik',
            site_desc: 'Dapatkan informasi tentang komik terupdate dan terkini.',
			site_keyword: 'komik update, komik update, komik musim ini, komik baru, komik terupdate',
            site_url: req.domain,
            data: data,
            nextPage,
            prevPage,
            currentPage: page
        });
    } catch (error) {
        console.error('Error fetching data:', error.response?.data || error.message);
        res.status(500).render('500', { 
            site_title: 'Terjadi Kesalahan | Komik',
            site_desc: 'Gagal mendapatkan data, coba lagi nanti',
            site_keyword: 'error',
            site_url: req.domain,
        });
    }
};
