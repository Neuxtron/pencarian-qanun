import React from 'react'
import icon from "../../_assets/icon.png"
import Image from 'next/image'
import LoginForm from './login_form'

function Login() {
  return (
    <main className='flex h-screen'>

      <div className='
        bg-white border-l-8 border-l-primary px-12 w-fit m-auto
        shadow-[4px_4px_8px_rgba(0,0,0,0.3)]
      '>
        <div className="flex items-center py-4 justify-center">
          <Image src={icon} alt='Pencarian Qanun' className='size-8' />
          <h1 className='text-primary text-xl font-semibold pl-3'>
            Admin Panel
          </h1>
        </div>

        <LoginForm />
      </div>
      
    </main>
  )
}

export default Login
