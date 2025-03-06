import { useState, createRef, KeyboardEventHandler } from "react"
import { MdClose } from "react-icons/md"
import { v4 } from "uuid"
import AppInput from "../app_input"
import FlatButton from "../flat_button"
import FormSection from "./form_section"

interface TagQanunProps {
  setTags: (tags: string[]) => void
  listTags: string[]
}
function TagQanun({ setTags, listTags }: TagQanunProps) {
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

export default TagQanun