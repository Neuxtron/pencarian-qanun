import { integerToRoman } from "@/app/_core/utils/helpers"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import OutlinedButton from "@/app/_shared/components/outlined_button"
import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import { v4 } from "uuid"
import styles from "./styles.module.css"
import Link from "next/link"
import { Komisi } from "@prisma/client"
import { getKomisi } from "@/app/_actions/komisi"
import ToastMessage from "./toast_message"

async function DaftarKomisi() {
  const listKomisi = await getKomisi()
  
  return (
    <MainLayout title="Daftar Komisi">
      <Link href="/komisi/tambah">
        <ElevatedButton>+ Tambah</ElevatedButton>
      </Link>
      <table className={styles.dataTable}>
        <TableHead />
        <TableBody listKomisi={listKomisi} />
      </table>
      <ToastMessage />
    </MainLayout>
  )
}

function TableHead() {
  return (
    <thead>
      <tr className="text-primary [&>*]:border-b-2 [&>*]:border-b-primary">
        <td className="text-center w-32">No. Komisi</td>
        <td className="w-auto">Nama Komisi</td>
        <td className="w-36 text-center">Aksi</td>
      </tr>
    </thead>
  )
}

interface TableBodyProps {
  listKomisi: Komisi[]
}
function TableBody({ listKomisi }: TableBodyProps) {
  return (
    <tbody>
      {listKomisi.length === 0 && (
        <tr><td colSpan={3} className="text-center">Tidak ada data komisi</td></tr>
      )}
      
      {listKomisi.map((komisi) => {
        const key = v4()
        const nomorKomisi = integerToRoman(komisi.nomorKomisi)
        
        return (
          <tr key={key}>
            <td className="text-center">{nomorKomisi}</td>
            <td className="w-auto">{komisi.nama}</td>
            <td>
              <Link href={`/komisi/edit/${komisi.id}`}>
                <OutlinedButton className="w-full">Edit</OutlinedButton>
              </Link>
            </td>
          </tr>
        )
      })}
    </tbody>
  )
}

export default DaftarKomisi