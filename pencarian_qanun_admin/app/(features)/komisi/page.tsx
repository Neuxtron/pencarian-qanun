import Komisi from "@/app/_core/models/komisi"
import { integerToRoman } from "@/app/_core/utils/helpers"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import OutlinedButton from "@/app/_shared/components/outlined_button"
import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import { v4 } from "uuid"
import styles from "./styles.module.css"
import db from "@/app/db"

async function DaftarKomisi() {
  const listKomisi = await getKomisi()
  
  return (
    <MainLayout title="Daftar Komisi">
      <ElevatedButton>+ Tambah</ElevatedButton>
      <table className={styles.dataTable}>
        <TableHead />
        <TableBody listKomisi={listKomisi} />
      </table>
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
            <td><OutlinedButton className="w-full">Edit</OutlinedButton></td>
          </tr>
        )
      })}
    </tbody>
  )
}

async function getKomisi(): Promise<Komisi[]> {
  const listKomisi: Komisi[] = await db.komisi.findMany()
  return listKomisi
}

export default DaftarKomisi