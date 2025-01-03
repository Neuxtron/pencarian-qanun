import { themeColors } from "@/app/_core/utils/constants"
import { ButtonHTMLAttributes, CSSProperties } from "react"
import styles from "./button.module.css"

interface OutlinedButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  className?: string
  color?: string
}
function OutlinedButton({ className, color = themeColors.primary, ...buttonProps }: OutlinedButtonProps) {
  return (
    <button
      className={`${styles.outlinedButton} ${className}`}
      style={{ '--color': color } as CSSProperties}
      type="button"
      {...buttonProps}
    />
  )
}

export default OutlinedButton