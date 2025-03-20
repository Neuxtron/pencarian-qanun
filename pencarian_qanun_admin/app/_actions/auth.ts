"use server"

import { cookies } from "next/headers"

export const getToken = async () => {
  const cookieStore = await cookies()
  const token = cookieStore.get("TOKEN")
  return token?.value
}

export const setToken = async (token: string) => {
  const cookieStore = await cookies()
  cookieStore.set("TOKEN", token)
}

export const removeToken = async () => {
  const cookieStore = await cookies()
  cookieStore.delete("TOKEN")
}