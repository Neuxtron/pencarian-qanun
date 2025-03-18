"use client"

import { getQanun, GetQanunArguments } from "@/app/_actions/qanun"
import ElevatedButton from "@/app/_shared/components/elevated_button"
import OutlinedButton from "@/app/_shared/components/outlined_button"
import Link from "next/link"
import { v4 } from "uuid"
import CariQanunForm from "./cari_qanun_form"
import FilterKomisiButton from "./filter_komisi_button"
import { useRef, useState } from "react"
import { Komisi, Prisma, Qanun, Tag } from "@prisma/client"
import { MdArrowDropDown, MdArrowDropUp } from "react-icons/md"
import styles from "./styles.module.css"

interface DaftarQanunContentProps {
  allQanun: Qanun[]
  listKomisi: Komisi[]
}
function DaftarQanunContent({ allQanun, listKomisi }: DaftarQanunContentProps) {
  const getQanunArgs = useRef<GetQanunArguments>({
    selectedOrder: { tahun: "desc" }
  })
  const [listQanun, setListQanun] = useState<Qanun[]>(allQanun)

  const handleKomisiChange = (idKomisi: string) => {
    getQanunArgs.current.komisi = idKomisi
    if (idKomisi === "") getQanunArgs.current.komisi = undefined
    updateQanunList()
  }
  const handleOrderQanun = (orderBy: Prisma.QanunOrderByWithRelationInput) => {
    getQanunArgs.current.selectedOrder = orderBy
    updateQanunList()
  }
  const handleSearch = (searchText: string) => {
    getQanunArgs.current.searchText = searchText
    updateQanunList()
  }

  const updateQanunList = async () => {
    const newListQanun = await getQanun(getQanunArgs.current)
    setListQanun(newListQanun)
  }

  const { komisi, selectedOrder, searchText } = getQanunArgs.current
  
  return (
    <>
      <CariQanunForm onSearch={handleSearch} />
      <PageActions
        selectedKomisi={komisi}
        onKomisiChange={handleKomisiChange}
        listKomisi={listKomisi}
      />
      <table className="data-table">
        <TableHead selectedOrder={selectedOrder} setOrder={handleOrderQanun} />
        <TableBody listQanun={listQanun} />
      </table>
    </>
  )
}

interface PageActionsProps {
  selectedKomisi?: string
  onKomisiChange: (idKomisi: string) => void
  listKomisi: Komisi[]
}
function PageActions({ selectedKomisi, onKomisiChange: handleKomisiChange, listKomisi }: PageActionsProps) {
  
  return (
    <div className="flex justify-between pt-8">
      <Link href="/qanun/tambah">
        <ElevatedButton>+ Tambah</ElevatedButton>
      </Link>
      <div className="flex flex-col items-end">
        <FilterKomisiButton
          listKomisi={listKomisi}
          selectedKomisi={selectedKomisi}
          onChange={handleKomisiChange}
        />
      </div>
    </div>
  )
}

interface TableHeadProps {
  selectedOrder: Prisma.QanunOrderByWithRelationInput
  setOrder: (orderBy: Prisma.QanunOrderByWithRelationInput) => void
}
function TableHead({ selectedOrder, setOrder }: TableHeadProps) {
  const toggleTahun = () => {
    if (selectedOrder.tahun === "asc") {
      setOrder({ tahun: "desc" })
      return
    }
    setOrder({ tahun: "asc" })
  }
  const toggleNomor = () => {
    if (selectedOrder.nomor === "asc") {
      setOrder({ nomor: "desc" })
      return
    }
    setOrder({ nomor: "asc" })
  }
  const toggleNama = () => {
    if (selectedOrder.nama === "asc") {
      setOrder({ nama: "desc" })
      return
    }
    setOrder({ nama: "asc" })
  }
  
  return (
    <thead className="select-none">
      <tr>
        <td className="w-4">#</td>
        <td className={`text-center w-24 ${styles.sortHead}`} onClick={toggleTahun}>
          <div>
            {selectedOrder.tahun === "asc" && <MdArrowDropUp />}
            {selectedOrder.tahun === "desc" && <MdArrowDropDown />}
            Tahun
          </div>
        </td>
        <td className={`text-center w-48 ${styles.sortHead}`} onClick={toggleNomor}>
          <div>
            {selectedOrder.nomor === "asc" && <MdArrowDropUp />}
            {selectedOrder.nomor === "desc" && <MdArrowDropDown />}
            Nomor Qanun
          </div>
        </td>
        <td className={`w-auto ${styles.sortHead}`} onClick={toggleNama}>
          <div>
            {selectedOrder.nama === "asc" && <MdArrowDropUp />}
            {selectedOrder.nama === "desc" && <MdArrowDropDown />}
            Nama Qanun
          </div>
        </td>
        <td className="w-36 text-center">Aksi</td>
      </tr>
    </thead>
  )
}

interface TableBodyProps {
  listQanun: Qanun[]
}
function TableBody({ listQanun }: TableBodyProps) {
  return (
    <tbody>
      {listQanun.length === 0 && (
        <tr><td colSpan={6} className="text-center">Tidak ada data Qanun</td></tr>
      )}
      
      {listQanun.map((qanun, index) => {
        const key = v4()
        return (
          <tr key={key} className="[&>*]:text-center">
            <td>{index + 1}</td>
            <td>{qanun.tahun}</td>
            <td>{qanun.nomor}</td>
            <td className="!text-left">{qanun.nama}</td>
            <td>
              <Link href={`/qanun/edit/${qanun.id}`}>
                <OutlinedButton className="w-full">Edit</OutlinedButton>
              </Link>
            </td>
          </tr>
        )
      })}
    </tbody>
  )
}

export default DaftarQanunContent