import { ReactElement } from "react"

export interface NavbarItem {
  href: string
  label: string
}

const navBars: NavbarItem[] = [
  {
    href: "/",
    label: "Dashboard"
  },
  {
    href: "/komisi",
    label: "Daftar Komisi"
  },
  {
    href: "/qanun",
    label: "Daftar Qanun"
  },
]

export default navBars