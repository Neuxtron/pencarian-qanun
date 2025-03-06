import { themeColors } from "@/app/_core/utils/constants"
import { ButtonHTMLAttributes } from "react"

interface ElevatedButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  color?: string
  className?: string
  disabled?: boolean
}
function ElevatedButton({ color = themeColors.primary, className, disabled = false, ...buttonProps }: ElevatedButtonProps) {
  return (
    <div className={`text-white w-fit text-sm h-fit ${className}`} style={{ backgroundColor: color }}>
      <button
        className={`
          duration-200 h-10 w-full px-5
          ${!disabled ? "hover:bg-white/30 hover:shadow-lg" : "bg-white/50 cursor-default"}
        `}
        type="button"
        disabled={disabled}
        {...buttonProps}
      />
    </div>
  )
}

export default ElevatedButton