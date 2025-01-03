"use client"

import { tambahKomisi } from "@/app/_actions/komisi"
import AppInput from "@/app/_shared/components/app_input"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import { useRouter } from "next/navigation"
import Swal from "sweetalert2"

function TambahForm() {
  const router = useRouter()
  
  const handleTambah = async (formData: FormData) => {
    const success = await tambahKomisi(formData)
    
    if (!success) {
      Swal.mixin({
        icon: "error",
        title: "Terjadi kesalahan",
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        timer: 1000,
      }).fire()
      return
    }

    router.push("/komisi?status=berhasil")
  }

  return (
    <div className="pl-8">
      <form className="w-96 [&>*]:w-full pt-12" action={handleTambah}>
        <AppInput
          id="nomorKomisi" placeholder="Nomor Komisi" type="number" min={1}
          required
        />
        <AppInput id="nama" placeholder="Nama Komisi" required />
        <div className="flex justify-end pt-3">
          <ElevatedButton type="submit">Tambah</ElevatedButton>
        </div>
      </form>
    </div>
  )
}

export default TambahForm