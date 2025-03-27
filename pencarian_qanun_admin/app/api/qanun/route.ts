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
      selectedOrder: [
        { komisi: { nomorKomisi: "asc" } },
        { nomor: "asc" },
      ],
      searchText: search,
      includeKomisi: true
    }
    const listQanun = await getQanun(args)

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