import { ReactNode } from "react"

interface FormSectionProps {
  title: string
  children?: ReactNode
  className?: string
}
function FormSection({ title, children }: FormSectionProps) {
  return (
    <div className="pt-6 flex flex-col relative">
      <p className="text-caption text-sm pb-1">{title}</p>
      {children}
    </div>
  )
}

export default FormSection