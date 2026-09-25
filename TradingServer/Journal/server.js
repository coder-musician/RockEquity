const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const PORT = 3000;

// Helper to get images from a folder
function getImages(folderPath, webPath) {
  return fs.readdirSync(folderPath)
           .filter(f => /\.(png|jpg|jpeg|gif|webp)$/i.test(f))
           .map(f => path.join(webPath, f).replace(/\\/g, "/"));
}

// Serve frontend
app.use(express.static('public'));
// Serve images
app.use('/images', express.static('images'));

// API endpoint: list all images dynamically
app.get('/api/images', (req, res) => {
  res.json({
    folder1: getImages(path.join(__dirname, 'images/folder1'), '/images/folder1'),
    folder2: getImages(path.join(__dirname, 'images/folder2'), '/images/folder2'),
    folder3: getImages(path.join(__dirname, 'images/folder3'), '/images/folder3')
  });
});

app.listen(PORT, () => console.log(`Server running at http://localhost:${PORT}`));

