const axios = require('axios');
require('dotenv').config();

exports.index = async (req, res) => {
    try {
        const q = req.query.q || '';
        const page = Number(req.query.page) || 1;
        const apiUrl = `${process.env.BASE_URL}/v1/search?q=${encodeURIComponent(q)}&page=${page}`;

        const response = await axios.get(apiUrl, {
            headers: { 'x-api-key': process.env.API_KEY }
        });

        const { data } = response.data; 
		
		const queryParams = new URLSearchParams({ q });
        const nextPage = data.length > 0 ? `?${queryParams.toString()}&page=${page + 1}` : null;
        const prevPage = page > 1 ? `?${queryParams.toString()}&page=${page - 1}` : null;

        res.render('search', { 
            site_title: 'Pencarian',
			site_desc: 'Temukan informasi anime yang Anda cari dengan mudah dan cepat.',
			site_keyword: 'pencarian, search, informasi, temukan, hasil pencarian',
            site_url: req.domain,
            data,
            nextPage,
            prevPage,
            currentPage: page
        });
    } catch (error) {
        console.error('Error fetching data:', error.response?.data || error.message);
        res.status(500).render('500', { 
            site_title: 'Terjadi Kesalahan',
            site_desc: 'Gagal mendapatkan data, coba lagi nanti',
            site_keyword: 'error',
            site_url: req.domain,
        });
    }
};
