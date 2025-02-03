// JavaScript to scroll the content container
function scrollLeft() {
    const container = document.querySelector('.scrollable-content');
    container.scrollBy({ left: -200, behavior: 'smooth' }); // Scrolls 200px to the left
}

function scrollRight() {
    const container = document.querySelector('.scrollable-content');
    container.scrollBy({ left: 200, behavior: 'smooth' }); // Scrolls 200px to the right
}