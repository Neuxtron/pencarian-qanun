// Get detail qanun

import db from "../../../db"

interface GetParams {
  params: Promise<{ id: string }>
}
export async function GET(_: Request, { params }: GetParams) {
  try {
    const { id } = await params
    const qanun = await db.qanun.findFirst({
      where: { id },
      include: {
        tags: true,
      }
    })

    const formattedQanun = {
      ...qanun,
      details: {
        tags: qanun?.tags,
        namaFile: qanun?.namaFile,
      }
    }
    delete formattedQanun.views
    delete formattedQanun.tags
    delete formattedQanun.namaFile
    
    return Response.json({
      status: true,
      message: "Berhasil mengambil data qanun",
      data: formattedQanun,
    })
  } catch (error) {
    console.log(error)
    return Response.json({
      status: false,
      message: "Terjadi kesalahan",
      data: {},
    }, { status: 500 })
  }
}