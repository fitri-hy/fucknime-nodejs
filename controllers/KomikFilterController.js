const axios = require('axios');
require('dotenv').config();

exports.index = async (req, res) => {
    try {
        const type = req.query.type || '';
        const order = req.query.order || '';
        const genre = req.query.genre || '';
        const status = req.query.status || '';
        const page = Number(req.query.page) || 1;

        const apiUrl = `${process.env.BASE_URL}/v1/komik/list?type=${type}&order=${order}&genre=${genre}&status=${status}&page=${page}`;
        const response = await axios.get(apiUrl, {
            headers: { 'x-api-key': process.env.API_KEY }
        });
        const { data } = response.data;

        const fetchFilter = async (url) => {
            try {
                const response = await axios.get(url, {
                    headers: { 'x-api-key': process.env.API_KEY }
                });
                return response.data?.data || [];
            } catch (error) {
                console.error(`Error fetching ${url}:`, error.response?.data || error.message);
                return [];
            }
        };

        const [filterOrder, filterType, filterGenre, filterStatus] = await Promise.all([
            fetchFilter(`${process.env.BASE_URL}/v1/komik/order`),
            fetchFilter(`${process.env.BASE_URL}/v1/komik/type`),
            fetchFilter(`${process.env.BASE_URL}/v1/komik/genre`),
            fetchFilter(`${process.env.BASE_URL}/v1/komik/status`)
        ]);

        const queryParams = new URLSearchParams({ genre, status, type, order });

        const nextPageUrl = data.length > 0 ? `?${queryParams.toString()}&page=${page + 1}` : null;
        const prevPageUrl = page > 1 ? `?${queryParams.toString()}&page=${page - 1}` : null;

        res.render('komik-filter', { 
            site_title: 'Filter | Komik',
            site_desc: 'Gunakan filter untuk menemukan komik sesuai preferensi Anda.',
			site_keyword: 'filter komik, sortir komik, pencarian komik, kategori komik, genre komik',
            site_url: req.domain,
            data,
            filterOrder,
            filterType,
            filterGenre,
            filterStatus,
            order,
            type,
            status,
            genre,
            nextPageUrl,
            prevPageUrl,
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
