import { getKomisi } from "@/app/_actions/komisi"
import FlatButton from "@/app/_shared/components/flat_button"
import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import Link from "next/link"
import { MdArrowBack } from "react-icons/md"
import EditQanunForm from "./edit_qanun_form"
import { getSingleQanun } from "@/app/_actions/qanun"
import { redirect } from "next/navigation"

interface EditQanunProps {
  params: Promise<{ idQanun: string }>
}
async function EditQanun({ params }: EditQanunProps) {
  const { idQanun } = await params
  const listKomisi = await getKomisi()
  const { qanun, listTags } = await getSingleQanun(idQanun)

  if (!qanun) redirect("/qanun")

  return (
    <MainLayout title="Edit Qanun">
      <KembaliButton />
      <EditQanunForm {...{listKomisi, qanun, listTags}} />
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

export default EditQanun