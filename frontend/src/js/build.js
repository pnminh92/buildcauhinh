import axios from 'axios'

export default class Build {
  static cancel (buildId) {
    axios.post(`/builds/${buildId}/cancel_edit`)
      .then(response => window.location = response.data.to)
      .catch(() => alertServerError())
  }

  static delete () {
    if (confirm('Bạn có chắc muốn xoá cấu hình này ?')) {
      document.querySelector('.build-info form').submit();
    } else {
      return
    }
  }
}