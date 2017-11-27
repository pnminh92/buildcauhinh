export default class Util {
  static displaySpinner () {
    document.querySelector('.main-content .box').innerHTML = `<div class="spinner"></div>`
  }

  static displayLoadMoreSpinner () {
    const blockViewMore = document.querySelector('.main-content .block-view-more')
    blockViewMore.querySelector('.btn').classList.add('hide')
    blockViewMore.classList.add('spinned')
    blockViewMore.insertAdjacentHTML('beforeend', `<div class="spinner spinner-load-more"></div>`)
  }

  static removeSpinner () {
    document.querySelector('.main-content .box .spinner').remove()
  }

  static removeLoadMoreSpinner () {
    const blockViewMore = document.querySelector('.main-content .block-view-more')
    blockViewMore.querySelector('.spinner-load-more').remove()
    blockViewMore.classList.remove('spinned')
    blockViewMore.querySelector('.btn').classList.remove('hide')
  }

  static alertServerError () {
    window.alert('Ứng dụng bị lỗi, vui lòng thử lại. Nếu vẫn không được xin gửi thông báo lỗi đến email buildcauhinh@gmail.com. Cám ơn!')
  }

  static escapeHtml (unsafe) {
    return unsafe
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#039;')
  }
}
