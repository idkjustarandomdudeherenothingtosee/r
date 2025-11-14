import { sign } from "./shared.js"

export const config = { runtime: "edge" }

export default async function handler(req) {
  const { searchParams } = new URL(req.url)
  const hwid = searchParams.get("hwid") || "none"

  const expires = Math.floor(Date.now() / 1000) + 30 // 30 sec token
  const payload = `${hwid}:${expires}`
  const signature = sign(payload)

  return new Response(
    JSON.stringify({
      token: signature,
      expires,
      payload
    }),
    { headers: { "Content-Type": "application/json" }}
  )
}
