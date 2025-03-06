"use client"

import { tambahKomisi } from "@/app/_actions/komisi"
import { showErrorToast } from "@/app/_core/utils/helpers"
import AppInput from "@/app/_shared/components/app_input"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import { useRouter } from "next/navigation"
import { useState } from "react"

function TambahKomisiForm() {
  const [isLoading, setLoading] = useState(false)
  const router = useRouter()
  
  const handleTambah = async (formData: FormData) => {
    setLoading(true)
    const success = await tambahKomisi(formData)
    setLoading(false)
    
    if (!success) {
      showErrorToast()
      return
    }

    const title = "Berhasil menambah komisi"
    router.push(`/komisi?icon=success&title=${title}`)
  }

  return (
    <div className="pl-8 pt-12">
      <form style={{ width: "28rem" }} className="[&>*]:w-full" action={handleTambah}>
        <AppInput
          id="nomorKomisi" placeholder="Nomor Komisi" type="number" min={1}
          required
        />
        <AppInput id="nama" placeholder="Nama Komisi" required />
        <div className="flex justify-end pt-3">
          <ElevatedButton type="submit" disabled={isLoading}>Tambah</ElevatedButton>
        </div>
      </form>
    </div>
  )
}

export default TambahKomisiForm