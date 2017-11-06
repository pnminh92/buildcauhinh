document.addEventListener('DOMContentLoaded', () => {
  const $menu = document.querySelector('.menu img')

  if ($menu) {
    $menu.addEventListener('click', () => {
      document.querySelector('.nav-dropdown').classList.toggle('open')
      document.querySelector('body').classList.toggle('nav-dropdown-open')
    })
  }
})
