window.localStorage.setItem('building_list', [])

export default class BuildingList {
  static displayItemNum() {
    const builder = document.querySelector('.builder')
    if (builder) {
      const num = window.localStorage.getItem('building_list').length
      const builder_num = builder.querySelector('.builder-num')
      if (builder_num) {
        builder_num.innerText = num
      } else {
        builder.insertAdjacentHTML('beforeend', `<span class="builder-num">${num}</span>`)
      }
    }
  }

  static addItem(hardware_id) {
    const hardware = window.sessionStorage.getItem('hardwares').find((hardware) => {
      return hardware.uuid == hardware_id
    })
    window.localStorage.getItem('building_list').push(hardware)
    this.displayItemNum()
  }

  static removeItem(hardware_id) {
    const pos = window.localStorage.getItem('building_list').findIndex((hardware) => { hardware.uuid == hardware_id })
    window.localStorage.getItem('building_list').splice(pos, 1)
    this.displayItemNum()
  }

  static create() {
    axios.post('/builds', { build: window.localStorage.getItem('building_list') })
      .then(response => {

      })
      .catch(error => {

      })
  }
}
