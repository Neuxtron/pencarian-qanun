// Get qanun by komisi

import db from "../../../db"

interface GetParams {
  params: Promise<{ idKomisi: string }>
}
export async function GET(_: Request, { params }: GetParams) {
  try {
    const { idKomisi } = await params
    const listQanun = await db.qanun.findMany({
      select: {
        id: true,
        nama: true,
        tahun: true,
        nomor: true,
      },
      where: { idKomisi },
      orderBy: [
        { tahun: "asc" },
        { nomor: "asc" },
      ]
    })
  
    const listTahun: number[] = []
    listQanun.forEach((qanun) => {
      if (!listTahun.includes(qanun.tahun)) listTahun.push(qanun.tahun)
    })
  
    const groupedByTahun = listTahun.map((tahun) => {
      const qanunByTahun = listQanun.filter((qanun) => qanun.tahun === tahun)
      return {
        tahun,
        data: qanunByTahun
      }
    })
  
    return Response.json({
      status: true,
      message: "Berhasil mengambil data qanun",
      data: groupedByTahun,
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