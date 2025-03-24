// Search qanun

import { getQanun, GetQanunArguments } from "@/app/_actions/qanun"

interface GetParams {
  searchParams: Promise<{ search: string }>
}
export async function GET(request: Request, { searchParams: params }: GetParams) {
  try {
    const { searchParams } = new URL(request.url)
    const search = searchParams.get("search") ?? ""
    const args: GetQanunArguments = {
      selectedOrder: { tahun: "desc" },
      searchText: search,
      includeKomisi: true
    }
    const listQanun = (await getQanun(args)).map(qanun => {
      const { nama: namaKomisi, nomorKomisi } = qanun.komisi
      return { ...qanun, namaKomisi, nomorKomisi }
    })

    return Response.json({
      status: true,
      message: "Berhasil mencari qanun",
      data: listQanun,
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