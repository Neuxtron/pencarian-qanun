import { InputHTMLAttributes } from "react"

interface AppInputProps extends InputHTMLAttributes<HTMLInputElement> {
  className?: string
  id: string
  placeholder: string
}
function AppInput({ className, id, placeholder, ...inputProps }: AppInputProps) {
  return (
    <input
      className={`
        bg-input py-2 px-4 mb-1 placeholder:text-primary
        ${className}
      `}
      id={id} name={id}
      placeholder={placeholder}
      autoComplete="off"
      {...inputProps}
    />
  )
}

export default AppInput