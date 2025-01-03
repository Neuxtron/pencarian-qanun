import { ReactNode } from "react"

interface OutlinedButtonProps {
  children?: ReactNode
  onClick?: () => void
  className?: string
}
function OutlinedButton({ children, onClick: handleClick, className }: OutlinedButtonProps) {
  return (
    <button
      className={`
        py-2 px-4 border-2 border-primary duration-200 hover:bg-primary
        hover:text-white text-primary text-sm
        ${className}
      `}
      onClick={handleClick}
    >
      {children}
    </button>
  )
}

export default OutlinedButton