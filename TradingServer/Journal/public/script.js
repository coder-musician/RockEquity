let imageData = {};
let currentIndexes = { folder1: 0, folder2: 0 };
let filteredImages = {};

async function fetchImages() {
  const res = await fetch('/api/images');
  imageData = await res.json();

  filteredImages = JSON.parse(JSON.stringify(imageData));
  updateImages();
}

function getActiveList(folder) {
  const searchOnly = document.getElementById("searchOnlyCheckbox").checked;
  return searchOnly ? filteredImages[folder] : imageData[folder];
}

function applyDateFilter(images) {
  const dateInput = document.getElementById("dateFilter").value;
  if (!dateInput) return images;

  const filterYYYYMMDD = dateInput.replace(/-/g, '');

  return images.filter(path => {
    const filename = path.split('/').pop();
    const parts = filename.split('-');
    if (parts.length < 3) return false;
    return parts[1] === filterYYYYMMDD;
  });
}

function updateImages() {
  const folders = ['folder1', 'folder2'];

  folders.forEach((folder, i) => {
    let images = getActiveList(folder);
    images = applyDateFilter(images);

    const imgElement = document.getElementById(`img${i + 1}`);
    const labelElement = document.getElementById(`label${i + 1}`);

    if (!images || images.length === 0) {
      imgElement.src = '';
      labelElement.textContent = 'No images';
      return;
    }

    const index = currentIndexes[folder] % images.length;
    imgElement.src = images[index];
    labelElement.textContent = images[index].split('/').pop();
  });
}

function navigate(direction) {
  const folders = ['folder1', 'folder2'];

  folders.forEach(folder => {
    let images = getActiveList(folder);
    images = applyDateFilter(images);

    if (!images || images.length === 0) return;

    if (direction === 'next') {
      currentIndexes[folder] = (currentIndexes[folder] + 1) % images.length;
    } else {
      currentIndexes[folder] =
        (currentIndexes[folder] - 1 + images.length) % images.length;
    }
  });

  updateImages();
}

function searchImages() {
  const query = document.getElementById('searchBox').value.toLowerCase();

  Object.keys(imageData).forEach(folder => {
    filteredImages[folder] = imageData[folder].filter(path =>
      path.toLowerCase().includes(query)
    );

    if (filteredImages[folder].length > 0) {
      currentIndexes[folder] = 0;
    }
  });

  updateImages();
}

document.getElementById("searchOnlyCheckbox")
  .addEventListener("change", () => {
    Object.keys(currentIndexes).forEach(folder => {
      currentIndexes[folder] = 0;
    });
    updateImages();
  });

document.getElementById("dateFilter")
  .addEventListener("change", () => {
    Object.keys(currentIndexes).forEach(folder => {
      currentIndexes[folder] = 0;
    });
    updateImages();
  });

document.addEventListener("keydown", (e) => {
  if (e.key === "ArrowRight") navigate('next');
  else if (e.key === "ArrowLeft") navigate('back');
  else if (e.key === "Enter") searchImages();
});

window.onload = fetchImages;
