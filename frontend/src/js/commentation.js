import axios from 'axios'

export default class Commentation {
  static openEditor (target, commentId, buildId) {
    const commentItemBody = target.parentNode.parentNode
    if (commentItemBody.classList.contains('editor-opened')) return
    const editorHtml = _.template(document.getElementById('edit-comment-form').innerHTML)({
      content: commentItemBody.querySelector('.comment-content').innerText,
      comment: { id: commentId, build_id: buildId }
    })
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

  static delete (target, commentId, buildId) {
    if (confirm('Bạn có chắc muốn xoá bình luận này ?')) {
      axios.delete(`/builds/${buildId}/comments/${commentId}`)
        .then(response => target.parentNode.parentNode.parentNode.remove())
        .catch(error => alertServerError())
    } else {
      return
    }
  }
}
