import { integerToRoman } from "@/app/_core/utils/helpers"
import { Komisi } from "@prisma/client"
import { ChangeEventHandler } from "react"
import { v4 } from "uuid"
import { MdArrowDropDown } from "react-icons/md"
import styles from "./styles.module.css"

interface FilterKomisiButtonProps {
  listKomisi: Komisi[]
  selectedKomisi?: string
  onChange: (idKomisi: string) => void
}
function FilterKomisiButton({ listKomisi, selectedKomisi, onChange: handleKomisiChange }: FilterKomisiButtonProps) {
  const handleFilter: ChangeEventHandler<HTMLSelectElement> = (e) => {
    const id = e.target.value
    handleKomisiChange(id)
  }
  
  return (
    <div className="relative flex items-center w-fit">
      <MdArrowDropDown className="absolute right-0 text-primary mb-1" size="1.2rem" />
      
      <select
        className={`
          max-w-72 text-ellipsis
          ${styles.actionDropdown}
        `}
        onChange={handleFilter}
        value={selectedKomisi}
      >
        <option value="" className="text-right">{selectedKomisi ? "----- Hapus Filter -----" : "----- Filter Komisi -----"}</option>
        {listKomisi.map((komisi) => {
          const key = v4()
          const nomorKomisi = integerToRoman(komisi.nomorKomisi)
      
          return (
            <option key={key} value={komisi.id}>
              Komisi {nomorKomisi} - {komisi.nama}
            </option>
          )
        })}
      </select>
    </div>
  )
}

export default FilterKomisiButton