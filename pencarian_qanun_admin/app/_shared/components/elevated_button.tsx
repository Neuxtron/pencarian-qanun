import { themeColors } from "@/app/_core/utils/constants"
import { ButtonHTMLAttributes, ReactNode } from "react"

interface ElevatedButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  color?: string
  className?: string
  disabled?: boolean
  chilren?: ReactNode
}
function ElevatedButton({ color = themeColors.primary, className, disabled = false, children, ...buttonProps }: ElevatedButtonProps) {
  return (
    <button
      className={`
        text-white w-fit text-sm h-10 px-5 relative duration-200
        ${className}
        ${!disabled ? "[&>div]:hover:bg-white/30 hover:shadow-lg" : "bg-white/50 cursor-default"}
      `}

      type="button"
      disabled={disabled}
      {...buttonProps}
      style={{ backgroundColor: color }}
    >
      <div className="absolute top-0 left-0 size-full duration-200" />
      {children}
    </button>
  )
}

export default ElevatedButton