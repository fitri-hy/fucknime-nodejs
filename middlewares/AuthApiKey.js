const apiKeyMiddleware = (req, res, next) => {
  const apiKeys = Array.isArray(req.headers['x-api-key']) ? req.headers['x-api-key'] : [req.headers['x-api-key']];
  const validApiKeys = ['I-AS_DEV-euV0A-eUJYm-OO60C-9OYQg'];

  const isValid = apiKeys.some(key => validApiKeys.includes(key));
  if (!isValid) {
    return res.status(403).json({ message: 'Fuck You 🖕!!. Invalid API Key ⛔' });
  }

  next();
};

module.exports = apiKeyMiddleware;
