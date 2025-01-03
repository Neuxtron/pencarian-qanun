import FlatButton from "@/app/_shared/components/flat_button"
import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import Link from "next/link"
import { MdArrowBack } from "react-icons/md"
import EditKomisiForm from "./edit_komisi_form"
import { getSingleKomisi } from "@/app/_actions/komisi"
import { redirect } from "next/navigation"

interface EditKomisiProps {
  params: Promise<{ idKomisi: string }>
}
async function EditKomisi({ params }: EditKomisiProps) {
  const { idKomisi } = await params
  const komisi = await getSingleKomisi(idKomisi)

  if (!komisi) {
    redirect("/komisi")
  }
  
  return (
    <MainLayout title="Edit Komisi">
      <KembaliButton />
      <EditKomisiForm komisi={komisi} />
    </MainLayout>
  )
}

function KembaliButton() {
  return (
    <Link href="/komisi">
      <FlatButton>
        <MdArrowBack className="mr-3" size="1.2rem" />
        Kembali
      </FlatButton>
    </Link>
  )
}


export default EditKomisi