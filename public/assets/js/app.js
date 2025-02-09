// Toggle Theme
const toggleButton = document.getElementById('theme-toggle');
const currentTheme = localStorage.getItem('theme');

if (currentTheme) {
  document.documentElement.setAttribute('data-theme', currentTheme);
  document.documentElement.classList.add(currentTheme);
} else {
  document.documentElement.setAttribute('data-theme', 'light');
  document.documentElement.classList.add('light');
}

toggleButton.addEventListener('click', () => {
  const currentMode = document.documentElement.getAttribute('data-theme');
  
  if (currentMode === 'light') {
    document.documentElement.setAttribute('data-theme', 'dark');
    document.documentElement.classList.remove('light');
    document.documentElement.classList.add('dark');
    localStorage.setItem('theme', 'dark');
  } else {
    document.documentElement.setAttribute('data-theme', 'light');
    document.documentElement.classList.remove('dark');
    document.documentElement.classList.add('light');
    localStorage.setItem('theme', 'light');
  }
});

// Modal search
const modal = document.getElementById('searchModal');
const modalContent = document.getElementById('searchModalContent');
const openBtn = document.getElementById('openSearchModal');
const closeBtn = document.getElementById('closeSearchModal');

function openModal() {
	modal.classList.remove('hidden');
	setTimeout(() => {
		modal.classList.add('opacity-100');
		modalContent.classList.remove('scale-75', 'opacity-0');
		modalContent.classList.add('scale-100', 'opacity-100');
	}, 10);
}

function closeModal() {
	modalContent.classList.remove('scale-100', 'opacity-100');
	modalContent.classList.add('scale-75', 'opacity-0');
	setTimeout(() => {
		modal.classList.remove('opacity-100');
		modal.classList.add('hidden');
	}, 300);
}

openBtn.addEventListener('click', openModal);
closeBtn.addEventListener('click', closeModal);
    
modal.addEventListener('click', function(event) {
	if (event.target === modal) {
		closeModal();
	}
});

// Menu sidebar
const menuBtnMenu = document.getElementById('menuBtnMenu');
const closeBtnMenu = document.getElementById('closeBtnMenu');
const sidebarMenu = document.getElementById('sidebarMenu');

menuBtnMenu.addEventListener('click', () => {
	sidebarMenu.classList.remove('translate-x-full');
});

closeBtnMenu.addEventListener('click', () => {
	sidebarMenu.classList.add('translate-x-full');
});