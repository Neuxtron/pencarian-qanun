// Get all komisi

import db from "../../db"

export async function GET() {
  try {
    const listKomisi = await db.komisi.findMany({
      orderBy: { nomorKomisi: "asc" }
    })
    return Response.json({
      status: true,
      message: "Berhasil mengambil data komisi",
      data: listKomisi,
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