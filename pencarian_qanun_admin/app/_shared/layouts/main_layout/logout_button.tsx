"use client"

import { MdLogout } from "react-icons/md"
import FlatButton from "../../components/flat_button"

function LogoutButton() {
  // TODO: handle logout
  const handleLogout = () => {}
  
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