"use client"

import { useRouter, useSearchParams } from "next/navigation"
import { useEffect } from "react"
import Swal, { SweetAlertIcon } from "sweetalert2"

function ToastMessage() {
  useShowToast()
  return null
}

function useShowToast() {
  const params = useSearchParams()
  const router = useRouter()
  
  useEffect(() => {
    const icon = params.get('icon')
    const title = params.get('title')
    if (!icon || !title) return
    Swal.mixin({
      toast: true,
      position: "top-end",
      icon: icon as SweetAlertIcon,
      title: title,
      timer: 3000,
      timerProgressBar: true,
      showConfirmButton: false,
      showCloseButton: true,
    }).fire()

    router.push(window.location.pathname)
  }, [params, router])
}

export default ToastMessage