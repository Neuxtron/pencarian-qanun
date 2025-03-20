"use client"

import { setToken } from '@/app/_actions/auth'
import { attemptLogin } from '@/app/_actions/users'
import AppInput from '@/app/_shared/components/app_input'
import ElevatedButton from '@/app/_shared/components/elevated_button'
import { useRouter } from 'next/navigation'
import React, { createRef } from 'react'
import Swal from 'sweetalert2'

function LoginForm() {
  const router = useRouter()
  const usernameRef = createRef<HTMLInputElement>()
  const passwordRef = createRef<HTMLInputElement>()
  
  const handleLogin: React.FormEventHandler<HTMLFormElement> = async (e) => {
    e.preventDefault()
    
    const username = usernameRef.current?.value
    const password = passwordRef.current?.value
    if (!username || !password) return
    
    const token = await attemptLogin(username, password)
    if (token) {
      await setToken(token)
      router.push("/")
    }
    showToast(token !== null)
  }

  const showToast = (valid: boolean) => {
    Swal.mixin({
      toast: true,
      position: "top-end",
      icon: valid ? "success" : "error",
      title: valid ? "Login berhasil" : "Username atau kata sandi salah",
      timer: 3000,
      timerProgressBar: true,
      showConfirmButton: false,
      showCloseButton: true,
    }).fire()
  }
  
  return (
    <form
      className='flex flex-col w-[26rem] pt-4 pb-12'
      onSubmit={handleLogin}
    >
      <AppInput ref={usernameRef} id='username' placeholder='Username' required />
      <AppInput ref={passwordRef} id='password' type='password' placeholder='Kata Sandi' required />
      <ElevatedButton className='mt-6 !px-10 self-end' type='submit'>Masuk</ElevatedButton>
    </form>
  )
}

export default LoginForm
