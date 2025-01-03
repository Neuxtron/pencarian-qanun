"use client"

import { useRouter, useSearchParams } from "next/navigation"
import { useEffect } from "react"
import Swal from "sweetalert2"

function ToastMessage() {
  const _ = useShowToast()
  return null
}

function useShowToast() {
  const params = useSearchParams()
  const status = params.get('status')
  const router = useRouter()
  
  useEffect(() => {
    if (status !== "berhasil") return
    Swal.mixin({
      toast: true,
      position: "top-end",
      icon: "success",
      title: "Berhasil menambah komisi",
      timer: 3000,
      timerProgressBar: true,
      showConfirmButton: false,
    }).fire()

    router.push(window.location.pathname)
  }, [])
}

export default ToastMessage