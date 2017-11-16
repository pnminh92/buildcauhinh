import axios from 'axios'

export default class HardwareList {
  static addItem (hardwareId) {
    axios.post(`/hardware_list/${hardwareId}`)
         .then(response => this._updateBuilderNum(response.data.num))
         .catch(error => alertServerError())
  }

  static removeItem (hardwareId, target) {
    axios.delete(`/hardware_list/${hardwareId}`)
         .then(response => {
           document.querySelector(`.form [type="hidden"][value="${hardwareId}"]`).remove()
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
