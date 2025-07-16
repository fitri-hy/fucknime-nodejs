const axios = require('axios');

async function ProtocolFallback(rawUrl) {
  const protocols = ['https://', 'http://'];

  for (const proto of protocols) {
    const fullUrl = proto + rawUrl;
    try {
      const response = await axios.get(fullUrl);
      if (response.status === 200) {
        return response.data;
      }
    } catch (error) {
      console.warn(`Access failed: ${fullUrl}`);
    }
  }

  throw new Error('Failed to retrieve data from all URLs');
}

module.exports = {
  ProtocolFallback
};
