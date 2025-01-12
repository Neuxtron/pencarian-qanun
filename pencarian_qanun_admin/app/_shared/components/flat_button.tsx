import { themeColors } from "@/app/_core/utils/constants"
import { ButtonHTMLAttributes, CSSProperties } from "react"
import styles from "./button.module.css"

interface FlatButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  className?: string
  color?: string
}
function FlatButton({ className, color = themeColors.primary, ...buttonProps }: FlatButtonProps) {
  return (
    <button
      className={`${styles.flatButton} ${className}`}
      type="button"
      style={{ '--color': color } as CSSProperties}
      {...buttonProps}
    />
  )
}

export default FlatButton