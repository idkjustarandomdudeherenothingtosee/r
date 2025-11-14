import crypto from "crypto"

// 32-byte key for AES-256
export const AES_KEY = crypto.randomBytes(32)
export const HMAC_SECRET = crypto.randomBytes(64)

// AES encrypt
export function encrypt(text) {
  const iv = crypto.randomBytes(16)
  const cipher = crypto.createCipheriv("aes-256-cbc", AES_KEY, iv)
  let encrypted = cipher.update(text, "utf8", "base64")
  encrypted += cipher.final("base64")
  return iv.toString("base64") + "." + encrypted
}

// AES decrypt
export function decrypt(payload) {
  const [ivStr, data] = payload.split(".")
  const iv = Buffer.from(ivStr, "base64")
  const decipher = crypto.createDecipheriv("aes-256-cbc", AES_KEY, iv)
  let decrypted = decipher.update(data, "base64", "utf8")
  decrypted += decipher.final("utf8")
  return decrypted
}

// HMAC sign
export function sign(data) {
  return crypto
    .createHmac("sha256", HMAC_SECRET)
    .update(data)
    .digest("hex")
}

// HMAC verify
export function verify(data, signature) {
  const expected = sign(data)
  return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expected))
}
