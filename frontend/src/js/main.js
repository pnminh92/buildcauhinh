import axios from 'axios'
import _ from './vendor/lodash.custom'
import Selectr from './vendor/selectr'

import HardwareList from './hardware_list'
import Build from './build'

_.templateSettings = {
  escape: /\{%-([\s\S]+?)%\}/g,
  evaluate: /\{%([\s\S]+?)%\}/g,
  interpolate: /\{%=([\s\S]+?)%\}/g
}
window._ = _

class Timgialinhkien {
  static toggleDropdown () {
    const $menu = document.querySelector('.menu img')
    const $body = document.querySelector('body')
    const $nav = document.querySelector('.nav-dropdown')

    if ($menu) {
      $menu.addEventListener('click', (e) => {
        $nav.classList.toggle('open')
        $body.classList.toggle('nav-dropdown-open')
        e.stopPropagation()
      })
      document.addEventListener('click', (e) => {
        if ($body.classList.contains('nav-dropdown-open')) {
          $nav.classList.remove('open')
          $body.classList.remove('nav-dropdown-open')
        }
      })
    }
  }

  static search (e) {
    e.preventDefault()
    const word = document.querySelector('.hardware-search-input .input-search').value
    if (!word) {
      window.location = '/'
      return
    }
    document.querySelector('#hardware-search-form').submit()
  }

  static openCommentEditor (target, commentId, buildId) {
    const commentItemBody = target.parentNode.parentNode
    if (commentItemBody.classList.contains('editor-opened')) return
    const editorHtml = _.template(document.getElementById('edit-comment-form').innerHTML)({
      content: commentItemBody.querySelector('.comment-content').innerText,
      comment: { id: commentId, build_id: buildId }
    })
    commentItemBody.insertAdjacentHTML('beforeend', editorHtml)
    commentItemBody.classList.add('editor-opened')
  }

  static closeCommentEditor (target) {
    const commentItemBody = target.parentNode.parentNode.parentNode
    commentItemBody.querySelector('.edit-comment-form').remove()
    commentItemBody.classList.remove('editor-opened')
  }

  static editComment (target, commentId, buildId) {
    const commentItemBody = target.parentNode.parentNode.parentNode
    axios.patch(`/builds/${buildId}/comments/${commentId}`, { content: commentItemBody.querySelector('textarea').value })
      .then(response => {
        commentItemBody.querySelector('.edit-comment-form').remove()
        commentItemBody.classList.remove('editor-opened')
        commentItemBody.querySelector('.comment-content').innerHTML = _.escape(response.data.content)
      })
      .catch(error => {
        if (error.response.data) {
          document.querySelector('.edit-comment-form .form-group').insertAdjacentHTML('beforeend', `<p class="model-text-error">${error.response.data.content}</p>`)
        } else {
          alertServerError()
        }
      })
  }

  static deleteComment (target, commentId, buildId) {
    if (confirm('Bạn có chắc muốn xoá bình luận này ?')) {
      axios.delete(`/builds/${buildId}/comments/${commentId}`)
        .then(response => target.parentNode.parentNode.parentNode.remove())
        .catch(error => alertServerError())
    } else {
      return
    }
  }

  static fadeOutFlash () {
    const flash = document.querySelector('.flash')
    if (flash) {
      setTimeout(() => {
        flash.classList.remove('flash-fade-out')
        setTimeout(() => flash.remove(), 400);
      }, 3000);
    }
  }

  static initSelectr (data) {
    const hardwareProvider = document.querySelector('.hardware-provider-select')
    if (!hardwareProvider) return
    return new Selectr(hardwareProvider, {
      defaultSelected: false,
      placeholder: 'Chọn cửa hàng',
      multiple: true,
      searchable: false,
      data: data
    })
  }
}


window.alertServerError = function () {
  alert('Server gặp sự cố. Vui lòng thử lại sau')
}
window.Timgialinhkien = Timgialinhkien
window.HardwareList = HardwareList
window.Build = Build

let selectrData = []
if (providers) {
  if (selectedProviders) {
    providers.forEach(provider => {
      if (selectedProviders.includes(provider.value)) {
        selectrData.push({ value: provider.value, text: provider.text, selected: true  })
      } else {
        selectrData.push({ value: provider.value, text: provider.text })
      }
    })
  } else {
    selectrData = providers
  }
}

document.addEventListener('DOMContentLoaded', () => {
  Timgialinhkien.toggleDropdown()
  Timgialinhkien.fadeOutFlash()
  Timgialinhkien.initSelectr(selectrData)
})
