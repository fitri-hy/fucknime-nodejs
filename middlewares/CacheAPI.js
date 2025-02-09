const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 300, checkperiod: 320 });

const cacheMiddleware = (req, res, next) => {
  const key = req.originalUrl;
  const cachedData = cache.get(key);
  
  if (cachedData) {
    return res.json(cachedData);
  }
  
  res.cacheKey = key;
  next();
};

const setCache = (key, data) => {
  cache.set(key, data);
};

module.exports = { cacheMiddleware, setCache };
