// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

function appendChatMessage(container, className, label, text) {
  const message = document.createElement("div")
  message.className = className

  const heading = document.createElement("strong")
  heading.textContent = label

  message.append(heading, document.createTextNode(` ${text}`))
  container.append(message)

  return message
}

function initializeChatbot() {
  const chatbot = document.getElementById("chatbot-flotante")
  if (!chatbot) return

  const minimizeButton = document.getElementById("btn-minimizar-chat")
  const header = document.getElementById("header-chat")
  const input = document.getElementById("input-chat")
  const sendButton = document.getElementById("btn-enviar-chat")
  const messages = document.getElementById("chat-mensajes")

  function toggleChat() {
    const minimized = chatbot.classList.toggle("chat-minimizado")
    minimizeButton.textContent = minimized ? "＋" : "−"
    minimizeButton.setAttribute("aria-label", minimized ? "Abrir chat" : "Minimizar chat")
    minimizeButton.setAttribute("aria-expanded", String(!minimized))

    if (!minimized) input.focus()
  }

  minimizeButton.addEventListener("click", toggleChat)
  header.addEventListener("click", (event) => {
    if (!event.target.closest("button")) toggleChat()
  })
  sendButton.addEventListener("click", sendMessage)
  input.addEventListener("keydown", (event) => {
    if (event.key === "Enter") sendMessage()
  })

  async function sendMessage() {
    const message = input.value.trim()
    if (!message || sendButton.disabled) return

    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    if (!csrfToken) {
      appendChatMessage(messages, "mensaje-ia", "Chat de Soporte:", "No se pudo enviar el mensaje. Recarga la página e inténtalo de nuevo.")
      return
    }

    appendChatMessage(messages, "mensaje-usuario", "Tú:", message)
    input.value = ""

    const typingIndicator = appendChatMessage(messages, "mensaje-ia escribiendo", "Chat de Soporte:", "Escribiendo...")
    messages.scrollTop = messages.scrollHeight
    input.disabled = true
    sendButton.disabled = true

    try {
      const response = await fetch("/chat/preguntar", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken
        },
        body: JSON.stringify({ mensaje: message })
      })

      if (!response.ok) throw new Error(`Chat request failed with status ${response.status}`)

      const data = await response.json()
      if (typeof data.respuesta !== "string") throw new Error("Chat response did not include a valid answer")

      typingIndicator.remove()
      appendChatMessage(messages, "mensaje-ia", "Chat de Soporte:", data.respuesta)
    } catch (error) {
      console.error("No se pudo enviar el mensaje al asistente:", error)
      typingIndicator.remove()
      appendChatMessage(messages, "mensaje-ia", "Chat de Soporte:", "Error de conexión. Inténtalo de nuevo.")
    } finally {
      input.disabled = false
      sendButton.disabled = false
      input.focus()
      messages.scrollTop = messages.scrollHeight
    }
  }
}

document.addEventListener("turbo:load", initializeChatbot)
