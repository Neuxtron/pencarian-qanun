import { integerToRoman } from "@/app/_core/utils/helpers"
import { Komisi, Qanun } from "@prisma/client"
import { ChangeEventHandler } from "react"
import { MdArrowDropDown } from "react-icons/md"
import { v4 } from "uuid"
import AppInput from "../app_input"
import FormSection from "./form_section"

interface RincianQanunProps {
  listKomisi: Komisi[]
  selectedKomisi: string | undefined
  setKomisi: (idString: string | undefined) => void
  qanun?: Qanun
}
function RincianQanun({ listKomisi, selectedKomisi, setKomisi, qanun }: RincianQanunProps) {
  const handleKomisiChange: ChangeEventHandler<HTMLSelectElement> = (e) => {
    setKomisi(e.currentTarget.value)
  }

  return (
    <FormSection title="Rincian Qanun">
      <AppInput id="tahun" placeholder="Tahun" type="number" required defaultValue={qanun?.tahun} />
      <AppInput id="nomor" placeholder="Nomor Qanun" type="number" required defaultValue={qanun?.nomor} />
      <AppInput id="nama" placeholder="Nama Qanun" required defaultValue={qanun?.nama} />
      <div className="relative flex items-center">
        <select
          name="idKomisi" id="idKomisi"
          value={selectedKomisi} onChange={handleKomisiChange}
          className="
            w-full bg-input py-2 pl-4 pr-10 mb-1 placeholder:text-primary text-sm
            !text-ellipsis appearance-none
          "
          required
        >
          <option value="">----- Pilih Komisi -----</option>
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

        <MdArrowDropDown className="absolute right-3 mb-2" size="1.2rem" />
      </div>
    </FormSection>
  )
}

export default RincianQanun