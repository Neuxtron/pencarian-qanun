import { themeColors } from "@/app/_core/utils/constants"
import { ButtonHTMLAttributes } from "react"

interface ElevatedButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  color?: string
  className?: string
}
function ElevatedButton({ color = themeColors.primary, className, ...buttonProps }: ElevatedButtonProps) {
  return (
    <div className={`text-white w-fit text-sm ${className}`} style={{ backgroundColor: color }}>
      <button
        className="duration-200 hover:bg-white/20 hover:shadow-lg py-2 px-5"
        type="button"
        {...buttonProps}
      />
    </div>
  )
}

export default ElevatedButton