"use client"

import { PieChart, PieValueType } from '@mui/x-charts'
import { MakeOptional } from '@mui/x-charts/internals'
import React from 'react'

interface QanunChartProps {
  data: MakeOptional<PieValueType, "id">[]
}
function QanunChart({ data }: QanunChartProps) {
  return (
    <PieChart
      className="flex-grow-0 size-44 [&_.MuiChartsLegend-root]:hidden"
      series={[
        {
          data,
          innerRadius: 55,
          outerRadius: 80,
          paddingAngle: 5,
          startAngle: -179,
          endAngle: 180,
          cx: 75,
          valueFormatter: (value) => "",
        }
      ]}
    />
  )
}

export default QanunChart
