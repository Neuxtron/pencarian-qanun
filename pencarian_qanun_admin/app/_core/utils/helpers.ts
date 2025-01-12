import Swal from "sweetalert2"

export const integerToRoman = (num: number) => {
  const romanValues: { [key: string]: number } = {
    M: 1000,
    CM: 900,
    D: 500,
    CD: 400,
    C: 100,
    XC: 90,
    L: 50,
    XL: 40,
    X: 10,
    IX: 9,
    V: 5,
    IV: 4,
    I: 1
  }

  let roman = ''
  for (let key in romanValues) {
    while (num >= romanValues[key]) {
      roman += key
      num -= romanValues[key]
    }
  }
  return roman
}

export const objectFromForm = <T = { [k:string]: string }>(formData: FormData) => {
  const obj = Object.fromEntries(formData.entries())
  return obj as T
}

export const showErrorToast = () => {
  return Swal.mixin({
    icon: "error",
    title: "Terjadi kesalahan",
    toast: true,
    position: "top-end",
    showConfirmButton: false,
    timer: 3000,
  }).fire()
}