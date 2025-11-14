import { decrypt, encrypt, verify } from "./shared"

export const config = { runtime: "edge" }

let clients = []

function broadcast(msg, except = null) {
  for (const ws of clients) {
    if (ws !== except && ws.readyState === ws.OPEN) {
      ws.send(msg)
    }
  }
}

export default function handler(req) {
  if (req.headers.get("upgrade") !== "websocket") {
    return new Response("Not a websocket", { status: 400 })
  }

  const { socket, response } = Deno.upgradeWebSocket(req)
  let lastSent = 0

  socket.onopen = () => {
    clients.push(socket)
  }

  socket.onmessage = (event) => {
    try {
      const decrypted = JSON.parse(decrypt(event.data))

      // ---- 1) Token verification ----
      const { token, payload, msg } = decrypted
      if (!verify(payload, token)) {
        socket.close()
        return
      }

      // ---- 2) Expiration check ----
      const [hwid, expires] = payload.split(":")
      if (Date.now() / 1000 > Number(expires)) {
        socket.close()
        return
      }

      // ---- 3) Anti-flood (1 msg per 500ms) ----
      if (Date.now() - lastSent < 500) return
      lastSent = Date.now()

      // ---- 4) Broadcast ----
      const out = encrypt(JSON.stringify({
        hwid: hwid,
        msg: msg,
        time: Date.now()
      }))
      broadcast(out, socket)

    } catch (err) {
      socket.close()
    }
  }

  socket.onclose = () => {
    clients = clients.filter(c => c !== socket)
  }

  return response
}
