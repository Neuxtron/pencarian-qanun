"use client"

import { tambahQanun } from "@/app/_actions/qanun"
import { showErrorToast } from "@/app/_core/utils/helpers"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import QanunForm from "@/app/_shared/components/qanun_form/qanun_form"
import NewQanun from "@/app/_shared/models/new_qanun"
import { Komisi } from "@prisma/client"
import { useRouter } from "next/navigation"
import { useState } from "react"

interface TambahQanunFormProps {
  listKomisi: Komisi[]
}
function TambahQanunForm({ listKomisi }: TambahQanunFormProps) {
  const [isLoading, setLoading] = useState(false)
  const router = useRouter()

  const handleTambah = async (newQanun: NewQanun, listTags: string[]) => {
    setLoading(true)
    const success = await tambahQanun(newQanun, listTags)
    setLoading(false)
    if (!success) {
      showErrorToast()
      return
    }

    const title = "Berhasil menambah qanun"
    router.push(`/qanun?icon=success&title=${title}`)
  }

  const actions = (
    <ElevatedButton type="submit" disabled={isLoading}>Tambah</ElevatedButton>
  )
  
  return (
    <QanunForm
      listKomisi={listKomisi}
      onSubmit={handleTambah}
      formActions={actions}
    />
  )
}

export default TambahQanunForm