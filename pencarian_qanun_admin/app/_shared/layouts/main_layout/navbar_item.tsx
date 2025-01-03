"use client"

import { NavbarItem } from "@/app/_shared/data/navbars"
import Link from "next/link"
import { usePathname } from "next/navigation"

interface NavbarItemViewProps {
  navbar: NavbarItem
}
function NavbarItemView({ navbar }: NavbarItemViewProps) {
  const pathname = usePathname()
  const isSelected = navbar.href === pathname
  const twSelected = "text-white bg-primary font-bold"
  const twUnselected = "text-primary hover:pl-12 hover:bg-primary/10"
  
  return (
    <li className="w-full">
      <Link
        href={navbar.href}
        className={`
          text-primary w-full py-4 px-10 block duration-200
          ${isSelected ? twSelected : twUnselected}
        `}>
        {navbar.label}
      </Link>
    </li>
  )
}

export default NavbarItemView
