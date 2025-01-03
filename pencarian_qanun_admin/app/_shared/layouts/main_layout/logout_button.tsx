"use client"

import { MdLogout } from "react-icons/md"

function LogoutButton() {
  // TODO: handle logout
  const handleLogout = () => {}
  
  return (
    <button
      className="text-[#FF4500] flex ml-auto items-center hover:text-[#FF4500]/70 text-sm"
      onClick={handleLogout}
    >
      Logout
      <MdLogout className="ml-3" size="1.2rem" />
    </button>
  )
}

export default LogoutButton