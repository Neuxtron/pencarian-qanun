import { themeColors } from "@/app/_core/utils/constants"
import { ReactNode } from "react"

interface ElevatedButtonProps {
  children?: ReactNode
  color?: string
  onClick?: () => void
  className?: string
}
function ElevatedButton({ children, color = themeColors.primary, onClick: handleClick, className }: ElevatedButtonProps) {
  return (
    <div className={`text-white w-fit text-sm ${className}`} style={{ backgroundColor: color }}>
      <button
        className="duration-200 hover:bg-white/20 hover:shadow-lg py-2 px-5"
        onClick={handleClick}
        type="button"
      >
        {children}
      </button>
    </div>
  )
}

export default ElevatedButton