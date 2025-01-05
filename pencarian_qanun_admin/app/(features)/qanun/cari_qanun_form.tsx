import { themeColors } from "@/app/_core/utils/constants"
import AppInput from "@/app/_shared/components/app_input"
import FlatButton from "@/app/_shared/components/flat_button"

function CariQanunForm() {
  return (
    <form className="flex items-center relative">
      <AppInput id="searchText" placeholder="Cari Qanun..." className="w-80 mr-2" />
      <FlatButton className="px-3 py-2 h-full" color={themeColors.primary}>Cari</FlatButton>
      <FlatButton className="px-3 py-2 h-full" color={themeColors.caption}>Batal</FlatButton>
    </form>
  )
}

export default CariQanunForm