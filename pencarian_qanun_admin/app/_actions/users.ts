"use server"

import db from "../db"
import bcrypt from "bcrypt"
import jwt from "jsonwebtoken"

export const attemptLogin = async (username: string, password: string): Promise<string | null> => {
  const user = await db.users.findFirst({
    where: { username }
  })
  if (!user) return null

  const valid = await bcrypt.compare(password, user.password)
  if (!valid) return null

  const secret = process.env.JWT_SECRET!
  const { id } = user
  const token = jwt.sign({ id }, secret)

  return token
}