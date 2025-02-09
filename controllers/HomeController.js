const axios = require('axios');
require('dotenv').config();

exports.index = async (req, res) => {
    try {
        const orders = ['publikasi', 'baru', 'populer', 'peringkat'];
        const requests = orders.map(order =>
            axios.get(`${process.env.BASE_URL}/v1/list?order=${order}`, {
                headers: { 'x-api-key': process.env.API_KEY }
            })
        );
        const responses = await Promise.all(requests);
        const [publikasi, baru, populer, peringkat] = responses.map(res => res.data.data);
		
		const response2 = await axios.get('http://localhost:3000/v1/filter/alphabet', {
            headers: { 'x-api-key': process.env.API_KEY }
        });
        const alphabet = response2.data.data;
		
		
        res.render('home', { 
            site_title: 'Beranda',
            site_desc: 'Selamat datang di FuckNime tempat nonton streaming anime sub indonesia.',
            site_keyword: 'anime, nonton anime, daftar anime, anime streaming, anime sub indo',
            site_url: req.domain,
            data: { publikasi, baru, populer, peringkat },
			alphabet 
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
