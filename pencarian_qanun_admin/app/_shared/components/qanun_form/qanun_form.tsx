"use client"

import { objectFromForm } from "@/app/_core/utils/helpers"
import NewQanun from "@/app/_shared/models/new_qanun"
import { Komisi, Qanun } from "@prisma/client"
import { FormEventHandler, ReactNode, useState } from "react"
import RincianQanun from "./rincian_qanun"
import TagQanun from "./tag_qanun"
import LampiranQanun from "./lampiran_qanun"
import { maxQanunSize } from "@/app/_core/utils/constants"

interface QanunFormProps {
  listKomisi: Komisi[]
  onSubmit: (newQanun: NewQanun, listTags: string[], oldFileName?: string) => void
  formActions: ReactNode
  qanun?: Qanun
  listTags?: string[]
}
function QanunForm({ listKomisi, onSubmit, formActions, qanun, listTags: defaultTags = [] }: QanunFormProps) {
  const [listTags, setTags] = useState<string[]>(defaultTags)
  const [fileError, setFileError] = useState("")
  const [komisi, setKomisi] = useState<string | undefined>(qanun?.idKomisi)

  const maxSizeMb = maxQanunSize
  const maxSize = maxSizeMb * 1024 * 1024

  const handleSubmit: FormEventHandler<HTMLFormElement> = async (e) => {
    setFileError("")
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    const newQanun = objectFromForm<NewQanun>(formData)
    newQanun.id = qanun?.id

    if (!qanun && newQanun.file.size === 0) {
      setFileError("Lampiran tidak boleh kosong")
      return
    }
    if (newQanun.file.size > maxSize) {
      setFileError(`Ukuran file tidak boleh lebih dari ${maxSizeMb}mb`)
      return
    }

    onSubmit(newQanun, listTags, qanun?.namaFile)
  }

  return (
    <div className="pl-8 pt-4">
      <form style={{ width: "28rem" }} className="[&>*]:w-full" onSubmit={handleSubmit}>
        <RincianQanun
          listKomisi={listKomisi}
          selectedKomisi={komisi}
          setKomisi={setKomisi}
          qanun={qanun}
        />
        <TagQanun listTags={listTags} setTags={setTags} />
        <LampiranQanun error={fileError} fileName={qanun?.namaFile} idQanun={qanun?.id} />
        <div className="pt-4 flex justify-end pb-4">
          {formActions}
      </div>
      </form>
    </div>
  )
}

export default QanunForm