"use server"

import { writeFile } from "fs/promises"
import NewQanun from "../_shared/models/new_qanun"
import db from "../db"
import { Prisma, Qanun } from "@prisma/client"
import path from "path"
import { qanunFolderPath } from "../_core/utils/constants"
import { unlink } from "fs/promises"

export interface GetQanunArguments {
  komisi?: string
  selectedOrder: Prisma.QanunOrderByWithRelationInput
  searchText?: string
}
export const getQanun = async ({ komisi, selectedOrder, searchText }: GetQanunArguments) => {
  // TODO: search with tags
  const listQanun = await db.qanun.findMany({
    where: { idKomisi: komisi },
    orderBy: selectedOrder,
  })
  return listQanun
}

export const getSingleQanun = async (id: string) => {
  const qanun: Qanun | null = await db.qanun.findFirst({ where: { id } })
  const listTagsRaw = await db.tag.findMany({ where: { idQanun: qanun?.id } })
  const listTags = listTagsRaw.map((tag) => tag.text)
  return { qanun, listTags }
}

export const tambahQanun = async (newQanun: NewQanun, listTags: string[]) => {
  try {
    const qanun = await db.qanun.create({
      data: {
        nama: newQanun.nama,
        idKomisi: newQanun.idKomisi,
        nomor: parseInt(newQanun.nomor),
        tahun: parseInt(newQanun.tahun),
        namaFile: newQanun.file.name
      }
    })

    const tagsData = listTags.map((text): Prisma.TagCreateManyInput => {
      return { text, idQanun: qanun.id }
    })
    await db.tag.createMany({
      data: tagsData
    })

    const buffer = Buffer.from(await newQanun.file.arrayBuffer())
    const fileName = `${qanun.id} - ${newQanun.file.name}`
    await writeFile(
      path.join(process.cwd(), "public", qanunFolderPath, fileName),
      buffer
    )
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}

export const editQanun = async (newQanun: NewQanun, listTags: string[], oldFileName?: string) => {
  const fileChanged = newQanun.file.size !== 0
  
  try {
    await db.qanun.update({
      data: {
        nama: newQanun.nama,
        idKomisi: newQanun.idKomisi,
        nomor: parseInt(newQanun.nomor),
        tahun: parseInt(newQanun.tahun),
        namaFile: fileChanged ? newQanun.file.name : undefined
      },
      where: { id: newQanun.id }
    })
    
    const existingTags = (await db.tag.findMany({
      where: { idQanun: newQanun.id }
    })).map(tag => tag.text)
    const newTags = listTags.filter(tag => !existingTags.includes(tag))
    const deletedTags = existingTags.filter(tag => !listTags.includes(tag))

    const newTagsData = newTags.map((text): Prisma.TagCreateManyInput => {
      return { text, idQanun: newQanun.id! }
    })
    await db.tag.createMany({ data: newTagsData })
    await db.tag.deleteMany({ where: {
      idQanun: newQanun.id,
      text: { in: deletedTags }
    }})
    if (!fileChanged) return true

    const fileName = `${newQanun.id} - ${oldFileName}`
    const filePath = path.join(process.cwd(), "public", qanunFolderPath, fileName)
    await unlink(filePath).catch(err => console.log(err))

    const buffer = Buffer.from(await newQanun.file.arrayBuffer())
    const newFileName = `${newQanun.id} - ${newQanun.file.name}`
    await writeFile(
      path.join(process.cwd(), "public", qanunFolderPath, newFileName),
      buffer
    )
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}

export const hapusQanun = async (qanun: Qanun) => {
  try {
    const fileName = `${qanun.id} - ${qanun.namaFile}`
    const filePath = path.join(process.cwd(), "public", qanunFolderPath, fileName)
    await unlink(filePath).catch(err => console.log(err))
    await db.qanun.delete({ where: { id: qanun.id } })
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}