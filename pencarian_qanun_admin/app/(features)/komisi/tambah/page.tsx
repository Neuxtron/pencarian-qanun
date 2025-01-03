import AppInput from "@/app/_shared/components/app_input"
import FlatButton from "@/app/_shared/components/flat_button"
import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import Link from "next/link"
import { MdArrowBack } from "react-icons/md";
import TambahForm from "./tambah_form"

function TambahKomisi() {
  return (
    <MainLayout title="Komisi Baru">
      <KembaliButton />
      <TambahForm />
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