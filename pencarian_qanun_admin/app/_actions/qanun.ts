"use server"

import { writeFile } from "fs/promises"
import NewQanun from "../_shared/models/new_qanun"
import db from "../db"
import { Prisma, Qanun } from "@prisma/client"
import path from "path"
import { qanunFolderPath } from "../_core/utils/constants"
import { unlink } from "fs/promises"
import { v4 } from "uuid"

export interface GetQanunArguments {
  komisi?: string
  selectedOrder: Prisma.QanunOrderByWithRelationInput | Prisma.QanunOrderByWithRelationInput[]
  searchText?: string
  includeKomisi?: boolean
}

//-----/ READ /-----//
export const getQanun = async ({ komisi, selectedOrder, searchText, includeKomisi = false }: GetQanunArguments) => {
  const tags = searchText ? searchText?.split(" ") : null
  
  const allQanun = await db.qanun.findMany({
    include: { tags: true, komisi: includeKomisi },
    orderBy: selectedOrder,
    where: { idKomisi: komisi }
  })
  const nameResult = await db.qanun.findMany({
    where: {
      idKomisi: komisi,
      nama: { contains: searchText },
    },
    orderBy: selectedOrder,
    include: { komisi: includeKomisi }
  })

  const nameResultIds = nameResult.map((qanun) => qanun.id)
  const tagsResult = allQanun.filter((qanun) => {
    if (nameResultIds.includes(qanun.id)) return false
    if (!tags) return true
    const qanunTags = qanun.tags.map((tag) => tag.text)
    
    let valid = true
    tags.forEach((tag) => {
      if (!qanunTags.includes((tag))) valid = false
    })
    
    return valid
  })

  const allResult = [...tagsResult, ...nameResult]
  return allResult
}

export const getQanunPopuler = async () => {
  return await db.qanun.findMany({
    select: {
      nama: true,
      views: true,
    },
    orderBy: { views: "desc" },
    take: 3,
  })
}

export const getSingleQanun = async (id: string) => {
  const qanun: Qanun | null = await db.qanun.findFirst({ where: { id } })
  const listTagsRaw = await db.tag.findMany({ where: { idQanun: qanun?.id } })
  const listTags = listTagsRaw.map((tag) => tag.text)
  return { qanun, listTags }
}

export const getQanunCount = async () => await db.qanun.count()

//-----/ CREATE /-----//
export const tambahQanun = async (newQanun: NewQanun, listTags: string[]) => {
  try {
    const id = v4()

    // TODO: upload file
    const buffer = Buffer.from(await newQanun.file.arrayBuffer())
    const fileName = `${id} - ${newQanun.file.name}`
    await writeFile(
      path.join(process.cwd(), "public", qanunFolderPath, fileName),
      buffer
    )
    
    const qanun = await db.qanun.create({
      data: {
        id,
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
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}

//-----/ UPDATE /-----//
export const editQanun = async (newQanun: NewQanun, listTags: string[], oldFileName?: string) => {
  const fileChanged = newQanun.file.size !== 0
  
  try {
    if (fileChanged) {
      // TODO: delete in qanun file api
      const fileName = `${newQanun.id} - ${oldFileName}`
      const filePath = path.join(process.cwd(), "public", qanunFolderPath, fileName)
      await unlink(filePath).catch(err => console.log(err))

      // TODO: upload file
      const buffer = Buffer.from(await newQanun.file.arrayBuffer())
      const newFileName = `${newQanun.id} - ${newQanun.file.name}`
      await writeFile(
        path.join(process.cwd(), "public", qanunFolderPath, newFileName),
        buffer
      )
    }
    
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
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}

//-----/ DELETE /-----//
export const hapusQanun = async (qanun: Qanun) => {
  try {
    // TODO: delete in qanun file api
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