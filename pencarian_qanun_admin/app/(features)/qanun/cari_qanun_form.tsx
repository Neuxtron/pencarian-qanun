import { themeColors } from "@/app/_core/utils/constants"
import AppInput from "@/app/_shared/components/app_input"
import FlatButton from "@/app/_shared/components/flat_button"
import { createRef, FormEventHandler } from "react"

interface CariQanunFormProps {
  onSearch: (text: string) => void
}
function CariQanunForm({ onSearch }: CariQanunFormProps) {
  const searchRef = createRef<HTMLInputElement>()
  
  const handleSearch: FormEventHandler = (e) => {
    e.preventDefault()
    const value = searchRef.current?.value
    onSearch(value ?? "")
  }
  const handleReset = () => {
    onSearch("")
    if (searchRef.current?.value) searchRef.current.value = ""
  }
  
  return (
    <form className="flex items-center relative" onSubmit={handleSearch}>
      <AppInput
        ref={searchRef}
        id="searchText"
        placeholder="Cari Qanun..."
        className="w-80 mr-2"
      />

      <FlatButton
        className="px-3 py-2 h-full"
        color={themeColors.primary}
        onClick={handleSearch}
      >Cari</FlatButton>

      <FlatButton
        className="px-3 py-2 h-full"
        color={themeColors.caption}
        onClick={handleReset}
      >Batal</FlatButton>
    </form>
  )
}

export default CariQanunForm