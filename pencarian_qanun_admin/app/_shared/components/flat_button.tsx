import { themeColors } from "@/app/_core/utils/constants"
import { CSSProperties, ReactNode } from "react"
import styles from "./flat_button.module.css"

interface FlatButtonProps {
  onClick?: () => void
  children?: ReactNode
  className?: string
  color?: string
}
function FlatButton({ onClick: handleClick, children, className, color = themeColors.primary }: FlatButtonProps) {
  return (
    <button
      className={`${styles.flatButton} ${className}`}
      onClick={handleClick}
      style={{ '--color': color } as CSSProperties}
    >
      {children}
    </button>
  )
}

export default FlatButton