const http = require('http');

const req = http.request('http://localhost/yarotech-api/public/api/reviews?product_id=1', (res) => {
  let data = '';
  res.on('data', chunk => { data += chunk; });
  res.on('end', () => {
    console.log("GET /reviews:", data);
  });
});
req.end();

const req2 = http.request('http://localhost/yarotech-api/public/api/reviews', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' }
}, (res) => {
  let data = '';
  res.on('data', chunk => { data += chunk; });
  res.on('end', () => {
    console.log("POST /reviews:", data);
  });
});
req2.write(JSON.stringify({
  product_id: '1',
  rating: 5,
  review_text: 'Test review'
}));
req2.end();
