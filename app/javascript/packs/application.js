document.addEventListener('DOMContentLoaded', () => {
    document.querySelector('.open-reviews-button').addEventListener('click', (e) => {
      e.preventDefault();
      const url = e.target.href;
      openModal(url);
    });
    
    document.querySelector()
    
    function openModal(url) {
      fetch(url, { headers: { 'Accept': 'text/javascript' } })
        .then(response => response.text())
        .then(html => {
          document.getElementById('reviews-modal-content').innerHTML = html;
          dialog.open();
        });
    }
});
