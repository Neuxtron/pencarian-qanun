import type { Metadata } from "next";
import "./globals.css";
import { CSSProperties } from "react"
import { themeColors } from "./_core/utils/constants"



export const metadata: Metadata = {
  title: "Admin Panel",
  description: "Admin panel untuk Pencarian Qanun",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const colorStyles = {
    '--primary': themeColors.primary,
    '--secondary': themeColors.secondary,
    '--accent': themeColors.accent,
    '--background': themeColors.background,
    '--text-primary': themeColors.textPrimary,
  } as CSSProperties
  
  return (
    <html lang="en">
      <body
        className="bg-background text-textPrimary font-poppins"
        style={colorStyles}
      >
        {children}
      </body>
    </html>
  );
}
