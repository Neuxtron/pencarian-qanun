import FlatButton from "@/app/_shared/components/flat_button"
import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import Link from "next/link"
import { MdArrowBack } from "react-icons/md"
import TambahQanunForm from "./tambah_qanun_form"
import { getKomisi } from "@/app/_actions/komisi"

async function TambahQanun() {
  const listKomisi = await getKomisi()
  
  return (
    <MainLayout title="Qanun Baru">
      <KembaliButton />
      <TambahQanunForm listKomisi={listKomisi} />
    </MainLayout>
  )
}

function KembaliButton() {
  return (
    <Link href="/qanun" className="w-fit block">
      <FlatButton>
        <MdArrowBack className="mr-3" size="1.2rem" />
        Kembali
      </FlatButton>
    </Link>
  )
}

export default TambahQanun