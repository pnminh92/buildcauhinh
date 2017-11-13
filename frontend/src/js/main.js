import axios from 'axios'
import _ from './vendor/lodash.custom'
import Selectr from './vendor/selectr'

_.templateSettings = {
  escape: /\{%-([\s\S]+?)%\}/g,
  evaluate: /\{%([\s\S]+?)%\}/g,
  interpolate: /\{%=([\s\S]+?)%\}/g
}
window._ = _

import BuildingList from './building_list'

class Timgialinhkien {
  static toggleDropdown () {
    const $menu = document.querySelector('.menu img')

    if ($menu) {
      $menu.addEventListener('click', () => {
        document.querySelector('.nav-dropdown').classList.toggle('open')
        document.querySelector('body').classList.toggle('nav-dropdown-open')
      })
    }
  }

  static signout () {
    axios.delete('/sign_out').then(() => window.location = '/').catch(() => this._echoServerError())
  }

  static search () {
    const word = document.querySelector('.hardware-search-input .input-search').value
    if (!word) return
    const postData = {
      word: word,
      providers: providerSelect.getValue()
    }
    axios.post('/search', postData)
         .then(response => {
           const mainContent = document.querySelector('.main-content')
           if (response.data) {
            const html = _.template(document.getElementById('result-search').innerHTML)(response.data)
            window.sessionStorage.setItem('hardwares', response.data.hardwares)
           }
         })
         .catch(() => this._echoServerError())
  }

  static createComment(build_id) {
    axios.post(`/builds/${build_id}/comments`, this._getCommentData())
      .then(response => {
        const html = _.template(document.getElementById('comment-item').innerHTML)(response.data)
        document.querySelector('.comment-list').insertAdjacentHTML('beforeend', html)
      })
      .catch(error => console.log(error))
  }

  static openCommentEditor(target, comment_id, build_id) {
    const commentItemBody = target.parentNode.parentNode
    if (commentItemBody.classList.contains('editor-opened')) return
    const editorHtml = _.template(document.getElementById('edit-comment-form').innerHTML)({
      content: commentItemBody.querySelector('.comment-content').innerText,
      comment: { id: comment_id, build_id: build_id }
    })
    commentItemBody.insertAdjacentHTML('beforeend', editorHtml)
    commentItemBody.classList.add('editor-opened')
  }

  static closeCommentEditor(target) {
    const commentItemBody = target.parentNode.parentNode.parentNode
    commentItemBody.querySelector('.edit-comment-form').remove()
    commentItemBody.classList.remove('editor-opened')
  }

  static editComment(target, comment_id, build_id) {
    const commentItemBody = target.parentNode.parentNode.parentNode
    axios.patch(`/builds/${build_id}/comments/${comment_id}`, { content: commentItemBody.querySelector('textarea').value })
      .then(response => {
        commentItemBody.querySelector('.edit-comment-form').remove()
        commentItemBody.classList.remove('editor-opened')
        commentItemBody.querySelector('.comment-content').innerHTML = _.escape(response.data.content)
      })
      .catch(() => this._echoServerError())
  }

  static deleteComment(target, comment_id, build_id) {
    axios.delete(`/builds/${build_id}/comments/${comment_id}`)
      .then(response => target.parentNode.parentNode.parentNode.remove())
      .catch(() => this._echoServerError())
  }

  static _echoServerError() {
    alert('Server gặp sự cố. Vui lòng thử lại sau')
  }

  static _getCommentData() {
    return {
      content: document.querySelector('.comment-content textarea').value
    }
  }
}

window.sessionStorage.setItem('hardwares', [])
window.Timgialinhkien = Timgialinhkien
window.BuildingList = BuildingList
const cacheHtmlMainContent
const providerSelect

document.addEventListener('DOMContentLoaded', () => {
  Timgialinhkien.toggleDropdown();
  BuildingList.displayItemNum();
  const hardwareProvider = document.querySelector('.hardware-provider-select')
  if (hardwareProvider) {
    providerSelect = new Selectr(hardwareProvider, {
      defaultSelected: false,
      placeholder: 'Chọn cửa hàng',
      multiple: true,
      searchable: false
    })
  }
})
