import axios from 'axios'
import _ from './vendor/lodash.custom'
import Selectr from './vendor/selectr'

import HardwareList from './hardware_list'
import Build from './build'
import Commentation from './commentation'

_.templateSettings = {
  escape: /\{%-([\s\S]+?)%\}/g,
  evaluate: /\{%([\s\S]+?)%\}/g,
  interpolate: /\{%=([\s\S]+?)%\}/g
}
window._ = _

axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name=csrf-token]').getAttribute('content')

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

  static loadMoreHardwares (target) {
    const nextInfo = JSON.parse(target.getAttribute('data-json'))
    if (!nextInfo.has_next) return
    axios.get('/', { params: { max_id: nextInfo.max_id } })
      .then(response => {
        const html = _.template(document.getElementById('hardware-item').innerHTML)(response.data)
        document.querySelector('.hardware-list').insertAdjacentHTML('beforeend', html)
        if (response.data.next_info.has_next) {
          target.setAttribute('data-json', JSON.stringify(response.data.next_info))
        } else {
          target.remove()
        }
      })
      .catch(() => alertServerError())
  }

  static loadMoreBuilds (target) {
    const nextInfo = JSON.parse(target.getAttribute('data-json'))
    if (!nextInfo.has_next) {
      target.remove()
      return
    }
    axios.get('/builds', { params: { max_id: nextInfo.max_id } })
      .then(response => {
        const html = _.template(document.getElementById('build-item').innerHTML)(response.data)
        document.querySelector('.build-items').insertAdjacentHTML('beforeend', html)
        if (response.data.next_info.has_next) {
          target.setAttribute('data-json', JSON.stringify(response.data.next_info))
        } else {
          target.remove()
        }
      })
      .catch(() => alertServerError())
  }

  static loadMoreUserBuilds (target) {
    const nextInfo = JSON.parse(target.getAttribute('data-json'))
    if (!nextInfo.has_next) {
      target.remove()
      return
    }
    const username = target.getAttribute('data-username')
    axios.get(`/${username}`, { params: { max_id: nextInfo.max_id } })
      .then(response => {
        const html = _.template(document.getElementById('build-item').innerHTML)(response.data)
        document.querySelector('.build-items').insertAdjacentHTML('beforeend', html)
        if (response.data.next_info.has_next) {
          target.setAttribute('data-json', JSON.stringify(response.data.next_info))
        } else {
          target.remove()
        }
      })
      .catch((error) => console.log(error))
  }
}


window.alertServerError = function () {
  alert('Server gặp sự cố. Vui lòng thử lại sau')
}
window.Timgialinhkien = Timgialinhkien
window.HardwareList = HardwareList
window.Build = Build
window.Commentation = Commentation

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
