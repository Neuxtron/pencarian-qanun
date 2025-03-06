"use client"

import { editKomisi, hapusKomisi } from "@/app/_actions/komisi"
import AppInput from "@/app/_shared/components/app_input"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import { useRouter } from "next/navigation"
import { showErrorToast } from "@/app/_core/utils/helpers"
import OutlinedButton from "@/app/_shared/components/outlined_button"
import { themeColors } from "@/app/_core/utils/constants"
import { Komisi } from "@prisma/client"
import Swal from "sweetalert2"
import { useState } from "react"

interface EditKomisiFormProps {
  komisi: Komisi
}
function EditKomisiForm({ komisi }: EditKomisiFormProps) {
    const [isLoading, setLoading] = useState(false)
  const router = useRouter()
  
  const handleEdit = async (formData: FormData) => {
    setLoading(true)
    const success = await editKomisi(formData, komisi.id)
    postAction(success, "Berhasil edit komisi")
  }

  const handleHapus = async () => {
    const result = await Swal.fire({
      icon: 'warning',
      title: "Apakah Anda ingin menghapus komisi ini?",
      showCancelButton: true,
      cancelButtonText: "Batal",
      confirmButtonColor: themeColors.danger,
      confirmButtonText: "Hapus",
      reverseButtons: true,
    })
    if (!result.isConfirmed) return

    setLoading(true)
    // TODO: delete qanun files
    const success = await hapusKomisi(komisi.id)
    postAction(success, "Berhasil hapus komisi")
    setLoading(false)
  }

  const postAction = (success: boolean, title: string) => {
    setLoading(false)
    if (!success) {
      showErrorToast()
      return
    }
    router.push(`/komisi?icon=success&title=${title}`)
  }
  
  return (
    <div className="pl-8">
      <form style={{ width: "28rem" }} className="[&>*]:w-full pt-12" action={handleEdit}>
        <AppInput
          id="nomorKomisi" placeholder="Nomor Komisi" type="number"
          min={1} defaultValue={komisi.nomorKomisi}
          required
        />
        <AppInput id="nama" placeholder="Nama Komisi" defaultValue={komisi.nama} required />
        
        <FormActions onHapus={handleHapus} isLoading={isLoading} />
      </form>
    </div>
  )
}

interface FormActionsProps {
  onHapus: () => void
  isLoading: boolean
}
function FormActions({ onHapus: handleHapus, isLoading }: FormActionsProps) {
  return (
    <div className="flex justify-end items-center pt-3">
      <OutlinedButton
        onClick={handleHapus}
        color={themeColors.danger}
        className="w-28 mr-2"
        disabled={isLoading}
      >
        Hapus
      </OutlinedButton>

      <ElevatedButton
        type="submit"
        className="!w-28"
        disabled={isLoading}
      >
        Edit
      </ElevatedButton>
    </div>
  )
}

export default EditKomisiForm