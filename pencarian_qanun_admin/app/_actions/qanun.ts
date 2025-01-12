"use server"

import { writeFile } from "fs/promises"
import NewQanun from "../_shared/models/new_qanun"
import db from "../db"
import { Prisma } from "@prisma/client"
import path from "path"

export interface GetQanunArguments {
  komisi?: string
  selectedOrder: Prisma.QanunOrderByWithRelationInput
  searchText?: string
}
export const getQanun = async ({ komisi, selectedOrder, searchText }: GetQanunArguments) => {
  // TODO: search with tags
  // TODO: remove
  // console.log(komisi)
  // console.log(selectedOrder)
  // console.log(searchText)

  const listQanun = await db.qanun.findMany({
    where: { idKomisi: komisi },
    orderBy: selectedOrder,
  })
  return listQanun
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

    await db.tag.createMany({
      data: listTags.map((text) => {
        return { text, idQanun: qanun.id }
      })
    })

    const buffer = Buffer.from(await newQanun.file.arrayBuffer())
    const fileName = `${Date.now()} - ${newQanun.file.name}`
    await writeFile(
      path.join(process.cwd(), "public/qanun/" + fileName),
      buffer
    )
    return true
  } catch (error) {
    console.log(error)
  }
  return false
}