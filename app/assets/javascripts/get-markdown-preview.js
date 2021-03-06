document.addEventListener("turbolinks:load", function() {
  const element = document.querySelector("[data-action='markdown-preview']")

  if (!element) return

  element.addEventListener("click", toggleMarkdownPreview)
})

function toggleMarkdownPreview(event) {
  event.preventDefault()

  const markdownElement = document.querySelector("[data-role='markdown-preview']")
  const descriptionElement = document.querySelector("[data-role='markdown-preview-wrapper']")

  if (this.dataset.active != "false") {
    this.dataset.active = "false"
    this.innerText = "Back to editing"
    descriptionElement.style.display = "none"

    sendParseRequest(descriptionElement, markdownElement)
  } else {
    this.dataset.active = "true"
    descriptionElement.style.display = "block"
    markdownElement.innerHTML = ""

    this.innerText = "Show Preview"
  }
}

function sendParseRequest(descriptionElement, markdownElement) {
  const descriptionValue = descriptionElement.querySelector("textarea").value

  markdownElement.innerHTML = "Loading preview..."

  fetch("/parse-markdown", {
    method: "post",
    body: JSON.stringify({ description: descriptionValue }),
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": Rails.csrfToken()
    },
    credentials: "same-origin"
  })
  .then(response => response.text())
  .then(data => {
    markdownElement.innerHTML = data
  })
}
