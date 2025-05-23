import { forwardRef, InputHTMLAttributes } from "react"

interface AppInputProps extends InputHTMLAttributes<HTMLInputElement> {
  className?: string
  id: string
  placeholder: string
}
const AppInput = forwardRef<HTMLInputElement, AppInputProps>(({ className, id, placeholder, ...inputProps }: AppInputProps, ref) => {
  return (
    <input
      ref={ref}
      className={`
        bg-input py-2 px-4 mb-1 placeholder:text-primary text-sm
        ${className}
      `}
      id={id} name={id}
      placeholder={placeholder}
      autoComplete="off"
      {...inputProps}
    />
  )
})

AppInput.displayName = "AppInput"

export default AppInput