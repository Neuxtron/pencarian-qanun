"use server"

import { Komisi } from "@prisma/client"
import db from "../db"
import { objectFromForm } from "../_core/utils/helpers"

export const getKomisi = async (): Promise<Komisi[]> => {
  const listKomisi: Komisi[] = await db.komisi.findMany({
    orderBy: { nomorKomisi: "asc" }
  })
  return listKomisi
}

export const getSingleKomisi = async (id: string): Promise<Komisi | null> => {
  const komisi: Komisi | null = await db.komisi.findFirst({ where: { id } })
  return komisi
}

export const tambahKomisi = async (formData: FormData) => {
  try {
    const raw = objectFromForm<{ [k: string]: string }>(formData)
    await db.komisi.create({ data: {
      nama: raw.nama,
      nomorKomisi: parseInt(raw.nomorKomisi),
    }})
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}

export const editKomisi = async (formData: FormData, id: string) => {
  try {
    const raw = objectFromForm<{ [k: string]: string }>(formData)
    await db.komisi.update({
      where: { id },
      data: {
        nama: raw.nama,
        nomorKomisi: parseInt(raw.nomorKomisi),
      },
    })
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}

export const hapusKomisi = async (id: string) => {
  // TODO: hapus file qanun
  try {
    await db.komisi.delete({ where: { id } })
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}