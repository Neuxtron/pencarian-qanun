import FlatButton from "@/app/_shared/components/flat_button"
import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import Link from "next/link"
import { MdArrowBack } from "react-icons/md";
import TambahKomisiForm from "./tambah_komisi_form"

function TambahKomisi() {
  return (
    <MainLayout title="Komisi Baru">
      <KembaliButton />
      <TambahKomisiForm />
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

export default TambahKomisi