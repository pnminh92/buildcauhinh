import axios from 'axios'
import Util from './util'

let currentPartType = null

export default class HardwareList {
  static togglePartType(target) {
    if (target.classList.contains('selected')) {
      currentPartType = null
      target.classList.remove('selected')
    } else {
      if (isFetching) return
      isFetching = true
      Util.displaySpinner()
      const hardware = JSON.parse(target.getAttribute('data-json'))
      document.querySelectorAll('.hardware-list li').forEach((ele) => ele.classList.remove('selected'))
      target.classList.add('selected')
      currentPartType = hardware.part
      axios.post('/search', { part: hardware.part })
        .then(response => {
          isFetching = false
          Util.removeSpinner()
          if (!response.data.html) return
          document.querySelector('.main-content .box').innerHTML = response.data.html
        })
        .catch(() => {
          isFetching = false
          Util.removeSpinner()
          Util.alertServerError()
        })
    }
  }

  static closeCurrentPartHardware(event) {
    if (isFetching) return
    isFetching = true
    const target = event.currentTarget
    const ele = target.parentNode
    const hardware = JSON.parse(ele.getAttribute('data-json'))
    event.stopPropagation()
    axios.post(`/hardware_list/${hardware.id}/remove`, { part: hardware.part })
        .then(response => {
          isFetching = false
          if (!response.data.deleted) return
          target.remove()
          ele.querySelector('p').remove()
          this._updateBuilderNum(response.data.num)
        })
        .catch(error => {
          isFetching = false
          Util.alertServerError()
        })
  }

  static addItem (target) {
    if (isFetching) return
    isFetching = true

    const hardware = JSON.parse(target.getAttribute('data-json'))
    if (currentPartType && currentPartType != hardware.part) {
      alert(`Linh kiện bạn chọn ráp là ${hardware.part} không phải là ${currentPartType}`)
      return
    }

    axios.post(`/hardware_list/${hardware.id}`, { part: currentPartType })
        .then(response => {
          isFetching = false
          const ele = document.querySelector(`li#${currentPartType}`)
          ele.setAttribute('data-json', JSON.stringify({ id: hardware.id, part: currentPartType }))
          if (response.data.replaced) {
            ele.querySelector('p').innerText = hardware.name
          } else {
            ele.querySelector('.build-close-btn').classList.add('open')
            ele.insertAdjacentHTML('beforeend', `<p>${hardware.name}</p>`)
            this._updateBuilderNum(response.data.num)
          }
        })
        .catch(error => {
          isFetching = false
          Util.alertServerError()
        })
  }

  static removeItem (target) {
    if (isFetching) return
    isFetching = true

    const hardware = JSON.parse(target.getAttribute('data-json'))
    axios.post(`/hardware_list/${hardware.id}/remove`, { part: hardware.part })
        .then(response => {
          isFetching = false
          if (!response.data.deleted) return
          const totalPriceDOM = document.querySelector(`form [type="hidden"][name="total_price"]`)
          const hardwareListDOM = document.querySelector('.hardware-list')
          totalPriceDOM.value -= hardware.price
          document.querySelector('#total-price').innerText = this._intToCurrency(totalPriceDOM.value)
          document.querySelector(`form [type="hidden"][value="${hardware.id}"]`).remove()
          target.parentNode.parentNode.remove()
          if (hardwareListDOM.querySelectorAll('tr').length < 3) hardwareListDOM.remove()
          this._updateBuilderNum(response.data.num)
        })
        .catch(() => {
          isFetching = false
          Util.alertServerError()
        })
  }

  static _updateBuilderNum(num) {
    const builderNum = document.querySelector('.builder-num')
    if (builderNum) builderNum.innerText = num
  }

  static _intToCurrency(price) {
    const tmp = price.toString()
                     .split('')
                     .reverse()
                     .reduce(function(o, v, k) { return (k % 3 == 2) ? '.' + v + o : v + o  }, '')  + ' VNĐ'
    return (tmp[0] == '.') ? tmp.slice(1) : tmp
  }
}
