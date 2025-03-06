"use client"

import QanunForm from "@/app/_shared/components/qanun_form/qanun_form"
import NewQanun from "@/app/_shared/models/new_qanun"
import { Komisi, Qanun } from "@prisma/client"
import EditQanunActions from "./edit_qanun_actions"
import { showErrorToast } from "@/app/_core/utils/helpers"
import { useRouter } from "next/navigation"
import { editQanun } from "@/app/_actions/qanun"
import { useState } from "react"

interface EditQanunFormProps {
  listKomisi: Komisi[]
  qanun: Qanun
  listTags: string[]
}
function EditQanunForm({ listKomisi, qanun, listTags }: EditQanunFormProps) {
  const [isLoading, setLoading] = useState(false)
  const router = useRouter()
  
  const handleEdit = async (newQanun: NewQanun, listTags: string[], oldFileName?: string) => {
    setLoading(true)
    const success = await editQanun(newQanun, listTags, oldFileName)
    if (!success) {
      showErrorToast()
      return
    }

    const title = "Berhasil edit qanun"
    router.push(`/qanun?icon=success&title=${title}`)
  }

  const postAction = (success: boolean, title: string) => {
    setLoading(false)
    if (!success) {
      showErrorToast()
      return
    }
    router.push(`/qanun?icon=success&title=${title}`)
  }

  return (
    <QanunForm
      onSubmit={handleEdit}
      formActions={(
        <EditQanunActions
          postHapus={postAction}
          {...{qanun, isLoading, setLoading}}
        />
      )}
      {...{listKomisi, qanun, listTags}}
    />
  )
}

export default EditQanunForm