document.addEventListener('DOMContentLoaded', function () {
  var notification = document.querySelector('.global-notification');
  if (notification) {
    window.setTimeout(function () { notification.remove(); }, 4000);
  }

  var burger = document.querySelector('.navbar-burger');
  if (burger) {
    burger.addEventListener('click', function () {
      burger.classList.toggle('is-active');
      document.getElementById(burger.dataset.target).classList.toggle('is-active');
    });
  }

  var fileInput = document.querySelector('.product-image');
  if (fileInput) {
    fileInput.addEventListener('change', function () {
      var preview = document.getElementById('list');
      preview.replaceChildren();
      var file = fileInput.files[0];
      if (file && file.type.startsWith('image/')) {
        var image = document.createElement('img');
        image.className = 'product-preview-thumb';
        image.alt = 'Selected product image';
        image.src = URL.createObjectURL(file);
        image.onload = function () { URL.revokeObjectURL(image.src); };
        preview.appendChild(image);
      }
    });
  }
});
