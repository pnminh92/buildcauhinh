import axios from 'axios'

window.currentPartType = null

export default class HardwareList {
  static togglePartType(target) {
    if (target.classList.contains('selected')) {
      currentPartType = null
      target.classList.remove('selected')
    } else {
      currentPartType = target.getAttribute('data-part-type')
      target.classList.add('selected')
    }
  }

  static closeCurrentPartHardware(target) {
    const ele = target.parentNode
    const partType = ele.getAttribute('data-part-type')
    axios.delete(`/hardware_list/${hardwareId}`, { part: partType })
        .then(response => {
          target.parentNode.querySelector('p').remove()
          this._updateBuilderNum(response.data.num)
        })
        .catch(error => alertServerError())
  }

  static addItem (hardwareId, target) {
    if (currentPartType) {
      axios.post(`/hardware_list/${hardwareId}`, { part: currentPartType })
          .then(response => {
            if (!response.data.updated) return
            const hardwareName = target.getAttribute('data-hardware-name')
            const ele = document.querySelector(`li[data-part-type=${currentPartType}]`)
            ele.insertAdjacentHTML('beforeend', `<p>${hardwareName}</p>`)
            ele.querySelector('.build-close-btn').addClass('open')
            this._updateBuilderNum(response.data.num)
          })
          .catch(error => alertServerError())
    } else {
      alert('Chọn loại linh kiện trước, rồi mới chọn linh kiện')
    }
  }

  static removeItem (hardwareId, target) {
    const partType = target.getAttribute('data-part-type')
    axios.delete(`/hardware_list/${hardwareId}`, { part_type: partType })
        .then(response => {
          document.querySelector(`form [type="hidden"][value="${hardwareId}"]`).remove()
          target.parentNode.parentNode.remove()
          this._updateBuilderNum(response.data.num)
        })
        .catch(error => alertServerError())
  }

  static _updateBuilderNum(num) {
    const builderNum = document.querySelector('.builder-num')
    if (builderNum) builderNum.innerText = num
  }
}
