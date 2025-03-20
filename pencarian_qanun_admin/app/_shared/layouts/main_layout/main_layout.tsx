import Image from "next/image"
import icon from "../../../_assets/icon.png"
import { v4 } from "uuid"
import NavbarItemView from "./navbar_item"
import navBars from "../../data/navbars"
import { ReactNode } from "react"
import LogoutButton from "./logout_button"

interface MainLayoutProps {
  title: string
  children?: ReactNode
}
function MainLayout({ title, children } : MainLayoutProps) {
  return (
    <main className="flex h-screen">
      <Navbar />
      <div className="flex-1 h-full w-full p-6 flex flex-col">
        <Header title={title} />
        <BodyContainer>{children}</BodyContainer>
      </div>
    </main>
  )
}

function Navbar() {
  return (
    <div className="flex flex-col items-center w-72 h-screen border-r-4 border-r-primary bg-white pt-10">
      <Image src={icon} alt="Pencarian Qanun" className="w-16 h-16" />
      <h1 className="font-bold text-2xl text-primary pt-4">Admin Panel</h1>
      <ul className="w-full pt-20">
        {navBars.map((navbar) => {
          const key = v4()
          return <NavbarItemView key={key} navbar={navbar} />
        })}
      </ul>
    </div>
  )
}

interface HeaderProps {
  title: string
}
function Header({ title }: HeaderProps) {
  return (
    <div className="
      bg-white h-16 border-l-8 border-l-primary flex items-center px-8 shadow-md
    ">
      <h1 className="text-2xl font-bold text-primary">{title}</h1>
      <LogoutButton />
    </div>
  )
}

interface BodyContainerProps {
  children: ReactNode
}
function BodyContainer({ children }: BodyContainerProps) {
  return (
    <div className="bg-white border-l-8 border-l-primary flex-1 mt-6 py-4 px-6 overflow-auto">
      {children}
    </div>
  )
}

export default MainLayout