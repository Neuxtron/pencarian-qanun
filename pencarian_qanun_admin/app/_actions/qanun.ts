"use server"

import db from "../db"
import { Prisma } from "@prisma/client"

export interface GetQanunArguments {
  komisi?: string
  selectedOrder: Prisma.QanunOrderByWithRelationInput
  searchText?: string
}
export const getQanun = async ({ komisi, selectedOrder, searchText }: GetQanunArguments) => {
  // TODO: search with tags
  // TODO: remove
  console.log(komisi)
  console.log(selectedOrder)
  console.log(searchText)

  const listQanun = await db.qanun.findMany({
    where: { idKomisi: komisi },
    orderBy: selectedOrder,
  })
  return listQanun
}