import axios from 'axios'
import Util from './util'

export default class Commentation {
  static openEditor (target, commentId, buildId) {
    const commentItemBody = target.parentNode.parentNode
    if (commentItemBody.classList.contains('editor-opened')) return
    const content = commentItemBody.querySelector('.comment-content').innerText
    const editorHtml = `
      <div class="edit-comment-form">
        <div class="form-group">
          <textarea class="textarea">${content}</textarea>
        </div>
        <div class="comment-btn">
          <button onclick="Commentation.edit(this, ${commentId}, ${buildId})" type="button" class="btn btn-sm">Sửa</button>
          <button onclick="Commentation.closeEditor(this)" type="button" class="btn btn-sm btn-gray">Đóng</button>
        </div>
      </div>
    `
    commentItemBody.insertAdjacentHTML('beforeend', editorHtml)
    commentItemBody.classList.add('editor-opened')
  }

  static closeEditor (target) {
    const commentItemBody = target.parentNode.parentNode.parentNode
    commentItemBody.querySelector('.edit-comment-form').remove()
    commentItemBody.classList.remove('editor-opened')
  }

  static edit (target, commentId, buildId) {
    const commentItemBody = target.parentNode.parentNode.parentNode
    axios.patch(`/builds/${buildId}/comments/${commentId}`, { content: commentItemBody.querySelector('textarea').value })
      .then(response => {
        commentItemBody.querySelector('.edit-comment-form').remove()
        commentItemBody.classList.remove('editor-opened')
        commentItemBody.querySelector('.comment-content').innerHTML = escapeHTML(response.data.content)
      })
      .catch(error => {
        if (error.response.data) {
          document.querySelector('.edit-comment-form .form-group').insertAdjacentHTML('beforeend', `<p class="model-text-error">${error.response.data.content}</p>`)
        } else {
          Util.alertServerError()
        }
      })
  }

  static delete (target, commentId, buildId) {
    if (confirm('Bạn có chắc muốn xoá bình luận này ?')) {
      axios.delete(`/builds/${buildId}/comments/${commentId}`)
        .then(response => target.parentNode.parentNode.parentNode.remove())
        .catch(error => Util.alertServerError())
    } else {
      return
    }
  }
}
