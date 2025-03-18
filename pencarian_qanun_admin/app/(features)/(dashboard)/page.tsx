import { getKomisiCount } from "@/app/_actions/komisi"
import { getQanunCount, getQanunPopuler } from "@/app/_actions/qanun"
import { themeColors } from "@/app/_core/utils/constants"
import MainLayout from "@/app/_shared/layouts/main_layout/main_layout"
import { PieChart, PieValueType } from "@mui/x-charts"
import { MakeOptional } from "@mui/x-charts/internals"
import { MdArrowForward, MdOutlineBook, MdOutlineCategory, MdOutlineVisibility } from "react-icons/md";
import Link from "next/link"
import { IconType } from "react-icons"

async function Dashboard() {
  const listQanunPopuler = await getQanunPopuler()
  const komisiCount = await getKomisiCount()
  const qanunCount = await getQanunCount()
  
  const colors = [
    themeColors.accent,
    themeColors.primary,
    "#1BAD02",
  ]
  
  const data: MakeOptional<PieValueType, "id">[] = listQanunPopuler.map((qanun, index) => {
    let views = qanun.views
    if (views === 0) views = 0.1
    
    return {
      value: views,
      color: colors[index]
    }
  })
  
  return (
    <MainLayout title="Dashboard">
      
      {/* Chart */}
      <div className="flex p-12">
        <div className="relative size-44">
          <PieChart
            className="flex-grow-0 size-44"
            series={[
              {
                data,
                innerRadius: 55,
                outerRadius: 80,
                paddingAngle: 5,
                startAngle: -179,
                endAngle: 180,
                cx: 75,
              }
            ]}
          />
          <div className="absolute h-full w-full top-0 left-0"></div>
        </div>

        {/* List */}
        <div className="pl-48">
          <h1 className="font-semibold text-3xl">Qanun Terpopuler</h1>
          <div className="w-[32rem] pt-8">
            {listQanunPopuler.map((qanun, index) => (
              <QanunItem
                color={colors[index]}
                number={index + 1}
                qanun={qanun}
                isLast={index === listQanunPopuler.length - 1}
              />
            ))}
          </div>
        </div>
      </div>

      {/* Total Komisi & Qanun */}
      <div className="flex gap-8 px-12 pt-6">
        <TotalItem
          Icon={MdOutlineCategory}
          label="Komisi"
          value={komisiCount}
          href="/komisi"
        />
        <TotalItem
          Icon={MdOutlineBook}
          label="Qanun"
          value={qanunCount}
          href="/qanun"
        />
      </div>
    </MainLayout>
  )
}

interface QanunItemProps {
  color: string
  number: number
  isLast: boolean
  qanun: {
    nama: string
    views: number
  }
}
function QanunItem({ color, number, qanun, isLast }: QanunItemProps) {
  return (
    <div className={`flex w-full items-center py-3 border-b ${isLast ? "" : "border-b-divider"}`}>
      <p
        style={{ backgroundColor: color }}
        className={`size-8 rounded-full text-white font-semibold flex items-center justify-center`}
      >
        #{number}
      </p>
      <p className="flex-1 px-3">{qanun.nama}</p>
      <div className="text-divider flex items-center">
        <MdOutlineVisibility className="text-2xl" />
        <p className="pl-3">{qanun.views}</p>
      </div>
    </div>
  )
}

interface TotalItemProps {
  Icon: IconType
  label: string
  value: number
  href: string
}
function TotalItem({ Icon, label, value, href }: TotalItemProps) {
  return (
    <Link
      href={href}
      className="
        w-[22rem] h-fit shadow-[0_0_8px_rgba(0,0,0,0.3)] border-b-8 border-b-primary select-none
        cursor-pointer [&_.selengkapnya]:hover:h-8 duration-200
      "
    >
      <div className="p-8 flex justify-between items-center">
        <Icon className="text-5xl text-primary" />
        <div className="text-right">
          <p>{label}</p>
          <h1 className="text-4xl font-semibold">{value}</h1>
        </div>
      </div>
      <div className="selengkapnya selengkapnya h-0 duration-200 overflow-hidden">
        <div className="
          flex text-caption justify-end items-center pr-4
        ">
          <p className="text-sm pr-2">Selengkapnya</p>
          <MdArrowForward className="text-xl block" />
        </div>
      </div>
    </Link>
  )
}

export default Dashboard