import { useState, ChangeEventHandler } from "react"
import { MdOutlineFileDownload, MdOutlineDescription, MdOutlineFileUpload } from "react-icons/md"
import FlatButton from "../flat_button"
import FormSection from "./form_section"
import Link from "next/link"
import { qanunFolderPath } from "@/app/_core/utils/constants"

interface LampiranQanunProps {
  error: string
  fileName?: string
  idQanun?: string
}
function LampiranQanun({ error, fileName, idQanun }: LampiranQanunProps) {
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
      <div className="relative flex items-center">
        <label
          htmlFor="file"
          className="
            flex items-center text-primary border-2 border-primary py-3 px-5 cursor-pointer
            rounded-lg duration-500 hover:bg-primary hover:text-white w-full flex-shrink-0
          "
          onMouseEnter={onHover}
          onMouseLeave={onUnHover}
        >
          <FileLabel fileName={file?.name ?? fileName} isHover={isHover} />
        </label>
        <DownloadButton
          show={fileName !== undefined && file === null}
          fileName={fileName}
          idQanun={idQanun}
        />
      </div>

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
        ? <MdOutlineDescription size="1.4rem" className="flex-shrink-0" />
        : <MdOutlineFileUpload size="1.4rem" className="flex-shrink-0" />
      }
      <p className="pl-3 overflow-hidden text-ellipsis">{getText()}</p>
    </>
  )
}

interface DownloadButtonProps {
  show: boolean
  fileName?: string
  idQanun?: string
}
function DownloadButton({ show, fileName, idQanun }: DownloadButtonProps) {
  if (!show) return

  const filePath = `${idQanun} - ${fileName}`
  
  return (
    <Link href={`/${qanunFolderPath}/${filePath}`}>
      <FlatButton className="whitespace-nowrap p-3">
        <MdOutlineFileDownload size="1.5rem" className="mr-2" />
        Download PDF
      </FlatButton>
    </Link>
  )
}

export default LampiranQanun