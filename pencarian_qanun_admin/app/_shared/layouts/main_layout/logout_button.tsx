"use client"

import { MdLogout } from "react-icons/md"
import FlatButton from "../../components/flat_button"
import { removeToken } from "@/app/_actions/auth"
import { useRouter } from "next/navigation"

function LogoutButton() {
  const router = useRouter()
  
  const handleLogout = async () => {
    await removeToken()
    router.push("/login")
  }
  
  return (
    <FlatButton
      className="ml-auto"
      onClick={handleLogout}
      color="#FF4500"
    >
      Logout
      <MdLogout className="ml-3" size="1.2rem" />
    </FlatButton>
  )
}

export default LogoutButton