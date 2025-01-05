import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import { getQanun } from "@/app/_actions/qanun"
import DaftarQanunContent from "./daftar_qanun_content"
import { getKomisi } from "@/app/_actions/komisi"

async function DaftarQanun() {
  const allQanun = await getQanun({
    selectedOrder: { tahun: "desc" }
  })
  const listKomisi = await getKomisi()
  
  return (
    <MainLayout title="Daftar Qanun">
      <DaftarQanunContent {...{allQanun, listKomisi}} />
    </MainLayout>
  )
}

export default DaftarQanun