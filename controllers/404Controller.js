exports.index = (req, res) => {
    res.status(404).render('404', { 
        site_title: 'Halaman Tidak Ada',
        site_desc: 'Halaman yang Anda cari tidak ditemukan atau telah dihapus.',
		site_keyword: 'halaman tidak ditemukan, error 404, halaman hilang, link mati, halaman tidak ada',
		site_url: req.domain
    });
};