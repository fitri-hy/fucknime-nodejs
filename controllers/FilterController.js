const axios = require('axios');
require('dotenv').config();

exports.index = async (req, res) => {
    try {
        const genre = req.query.genre || 'aksi';
        const status = req.query.status || '';
        const type = req.query.type || '';
        const order = req.query.order || 'default';
        const page = Number(req.query.page) || 1;

        const apiUrl = `${process.env.BASE_URL}/v1/filter/advance?genre=${genre}&status=${status}&tipe=${type}&order=${order}&page=${page}`;
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
            fetchFilter(`${process.env.BASE_URL}/v1/filter/order`),
            fetchFilter(`${process.env.BASE_URL}/v1/filter/type`),
            fetchFilter(`${process.env.BASE_URL}/v1/filter/genre`),
            fetchFilter(`${process.env.BASE_URL}/v1/filter/status`)
        ]);

        const queryParams = new URLSearchParams({ genre, status, type, order });

        const nextPageUrl = data.length > 0 ? `?${queryParams.toString()}&page=${page + 1}` : null;
        const prevPageUrl = page > 1 ? `?${queryParams.toString()}&page=${page - 1}` : null;

        res.render('filter', { 
            site_title: 'Filter',
            site_desc: 'Gunakan filter untuk menemukan anime sesuai preferensi Anda.',
			site_keyword: 'filter anime, sortir anime, pencarian anime, kategori anime, genre anime',
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
            site_title: 'Terjadi Kesalahan',
            site_desc: 'Gagal mendapatkan data, coba lagi nanti',
            site_keyword: 'error',
            site_url: req.domain,
        });
    }
};
