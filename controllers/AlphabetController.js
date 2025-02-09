const axios = require('axios');
require('dotenv').config();

exports.index = async (req, res) => {
    try {
		const show = req.query.show || "A";
        const page = parseInt(req.query.page) || 1;
        const apiUrl = `${process.env.BASE_URL}/v1/alphabet?show=${show}&page=${page}`;

        const response = await axios.get(apiUrl, {
            headers: { 'x-api-key': process.env.API_KEY }
        });
        const { data } = response.data;
		
		const response2 = await axios.get('http://localhost:3000/v1/filter/alphabet', {
            headers: { 'x-api-key': process.env.API_KEY }
        });
        const alphabet = response2.data.data;
		
		const queryParams = new URLSearchParams({ show });
        const nextPage = data.length > 0 ? `?${queryParams.toString()}&page=${page + 1}` : null;
        const prevPage = page > 1 ? `?${queryParams.toString()}&page=${page - 1}` : null;

        res.render('alphabet', { 
            site_title: `Berdasarkan ${show}`,
            site_desc: '',
			site_keyword: '',
            site_url: req.domain,
            data: data,
			show,
			alphabet,
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
