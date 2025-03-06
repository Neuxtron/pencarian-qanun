import { hapusQanun } from "@/app/_actions/qanun"
import { themeColors } from "@/app/_core/utils/constants"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import OutlinedButton from "@/app/_shared/components/outlined_button"
import { Qanun } from "@prisma/client"
import Swal from "sweetalert2"

interface EditQanunActionsProps {
  postHapus: (success: boolean, title: string) => void
  qanun: Qanun
  isLoading: boolean
  setLoading: (status: boolean) => void
}
function EditQanunActions({ postHapus, qanun, isLoading, setLoading }: EditQanunActionsProps) {
  const handleHapus = async () => {
    const result = await Swal.fire({
      icon: 'warning',
      title: "Apakah Anda ingin menghapus Qanun ini?",
      showCancelButton: true,
      confirmButtonColor: themeColors.primary,
    })
    if (!result.isConfirmed) return

    setLoading(true)
    const success = await hapusQanun(qanun)
    setLoading(false)
    postHapus(success, "Berhasil hapus Qanun")
  }
  
  return (
    <>
      <OutlinedButton
        className="w-28 mr-2"
        color={themeColors.danger}
        onClick={handleHapus}
        disabled={isLoading}
      >
        Hapus
      </OutlinedButton>
      
      <ElevatedButton
        className="!w-28"
        type="submit"
        disabled={isLoading}
      >
        Edit
      </ElevatedButton>
    </>
  )
}

export default EditQanunActions