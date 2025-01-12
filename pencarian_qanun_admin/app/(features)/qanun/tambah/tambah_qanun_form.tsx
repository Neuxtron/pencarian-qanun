"use client"

import { tambahQanun } from "@/app/_actions/qanun"
import { integerToRoman, objectFromForm, showErrorToast } from "@/app/_core/utils/helpers"
import AppInput from "@/app/_shared/components/app_input"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import FlatButton from "@/app/_shared/components/flat_button"
import NewQanun from "@/app/_shared/models/new_qanun"
import { Komisi } from "@prisma/client"
import { useRouter } from "next/navigation"
import { ChangeEventHandler, createRef, FormEventHandler, KeyboardEventHandler, ReactNode, useRef, useState } from "react"
import { MdOutlineFileUpload, MdOutlineDescription, MdClose, MdArrowDropDown } from "react-icons/md"
import { v4 } from "uuid"

interface TambahQanunFormProps {
  listKomisi: Komisi[]
}
function TambahQanunForm({ listKomisi }: TambahQanunFormProps) {
  const router = useRouter()
  const [listTags, setTags] = useState<string[]>([])
  const [fileError, setFileError] = useState("")
  const [komisi, setKomisi] = useState<string | undefined>(undefined)
  
  const handleTambah: FormEventHandler<HTMLFormElement> = async (e) => {
    setFileError("")
    e.preventDefault()
    const formData = new FormData(e.currentTarget)
    const newQanun = objectFromForm<NewQanun>(formData)

    if (newQanun.file.size === 0) {
      setFileError("Lampiran tidak boleh kosong")
      return
    }

    const success = await tambahQanun(newQanun, listTags)
    if (!success) {
      showErrorToast()
      return
    }

    const title = "Berhasil menambah qanun"
    router.push(`/qanun?icon=success&title=${title}`)
  }

  return (
    <div className="pl-8 pt-4">
      <form style={{ width: "28rem" }} className="[&>*]:w-full" onSubmit={handleTambah}>
        <RincianSection listKomisi={listKomisi} selectedKomisi={komisi} setKomisi={setKomisi} />
        <TagSection listTags={listTags} setTags={setTags} />
        <LampiranSection error={fileError} />
        <FormActions />
      </form>
    </div>
  )
}

interface RincianSectionProps {
  listKomisi: Komisi[]
  selectedKomisi: string | undefined
  setKomisi: (idString: string | undefined) => void
}
function RincianSection({ listKomisi, selectedKomisi, setKomisi }: RincianSectionProps) {
  const handleKomisiChange: ChangeEventHandler<HTMLSelectElement> = (e) => {
    setKomisi(e.currentTarget.value)
}
  
  return (
    <FormSection title="Rincian Qanun">
      <AppInput id="tahun" placeholder="Tahun" type="number" required />
      <AppInput id="nomor" placeholder="Nomor Qanun" type="number" required />
      <AppInput id="nama" placeholder="Nama Qanun" required />
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

interface TagSectionProps {
  setTags: (tags: string[]) => void
  listTags: string[]
}
function TagSection({ setTags, listTags }: TagSectionProps) {
  const [error, setError] = useState("")
  const tagRef = createRef<HTMLInputElement>()

  const handleTambahTag = () => {
    setError("")
    if (!tagRef.current || tagRef.current.value === "") return
    const text = tagRef.current.value.trim()
    const error = validateTag(text)

    if (error) return setError(error)
    
    const newListTags = [...listTags, text]
    tagRef.current.value = ""
    tagRef.current.focus()
    setTags(newListTags)
  }

  const handleHapusTag = (tag: string) => {
    const newListTags = listTags.filter((oldTag) => oldTag !== tag)
    setTags(newListTags)
  }

  const validateTag = (text: string): string | null => {
    if (listTags.includes(text)) return "Tag sudah ada"
    if (text.includes(" ")) return "Tag tidak boleh memiliki spasi"
    return null
  }

  const onKeyDown: KeyboardEventHandler<HTMLInputElement> = (e) => {
    if (e.key === "Enter") e.preventDefault()
  }
  
  return (
    <FormSection title="Tags (Opsional)">
      <div className="flex">
        <AppInput
        ref={tagRef}
        id="tag" placeholder="Masukkan Tag"
        className="flex-1" onKeyDown={onKeyDown}
      />
        <FlatButton
          className="!text-xs px-2"
          onClick={handleTambahTag}
        >
          + Tambah Tag
        </FlatButton>
      </div>

      <p className="text-sm text-red-500">{error}</p>

      <div className="w-full flex flex-wrap py-1">
        {listTags.map((tag) => {
          const key = v4()
          return (
            <TagItem key={key} text={tag} onHapus={handleHapusTag} />
          )
        })}
      </div>
    </FormSection>
  )
}

interface TagItemProps {
  text: string
  onHapus: (tag: string) => void
}
function TagItem({ text, onHapus }: TagItemProps) {
  const handleHapus = () => {
    onHapus(text)
  }
  
  return (
    <div className="
      rounded-full bg-primary text-white py-1 px-2 flex items-center
      text-sm h-fit m-1
    ">
      {text}
      <button className="ml-1" onClick={handleHapus}>
        <MdClose />
      </button>
    </div>
  )
}

interface LampiranSectionProps {
  error: string
}
function LampiranSection({ error }: LampiranSectionProps) {
  const [file, setFile] = useState<File | null>(null)
  const [isHover, setHover] = useState(false)

  const handleFilePick: ChangeEventHandler<HTMLInputElement> = (e) => {
    if (!e.target.files) return
    const file = e.target.files[0]
    setFile(file)
  }

  const onHover = () => setHover(true)
  const onUnHover = () => setHover(false)

  return (
    <FormSection title="Lampiran">
      <label
        htmlFor="file"
        className="
          flex items-center text-primary border-2 border-primary py-3 px-5 cursor-pointer
          rounded-lg duration-500 hover:bg-primary hover:text-white
        "
        onMouseEnter={onHover}
        onMouseLeave={onUnHover}
      >
        <FileLabel fileName={file?.name} isHover={isHover} />
      </label>

      <input
        type="file"
        name="file"
        id="file"
        className="hidden"
        onChange={handleFilePick}
      />
      <p className="text-sm text-red-500 pt-1">{error}</p>
      </FormSection>
  )
}

interface FileLabelProps {
  fileName?: string
  isHover: boolean
}
function FileLabel({ fileName, isHover }: FileLabelProps) {
  const getText = () => {
    if (!fileName) return "Upload PDF"
    if (isHover) return "Ubah File"
    return fileName
  }
  
  return (
    <>
      {
        fileName && !isHover
        ? <MdOutlineDescription size="1.4rem" />
        : <MdOutlineFileUpload size="1.4rem" />
      }
      <p className="pl-3">{getText()}</p>
    </>
  )
}

function FormActions() {
  return (
    <div className="pt-4 flex justify-end pb-4">
      <ElevatedButton type="submit">Tambah</ElevatedButton>
    </div>
  )
}

interface FormSectionProps {
  title: string
  children?: ReactNode
}
function FormSection({ title, children }: FormSectionProps) {
  return (
    <div className="pt-6 flex flex-col relative">
      <p className="text-caption text-sm pb-1">{title}</p>
      {children}
    </div>
  )
}

export default TambahQanunForm