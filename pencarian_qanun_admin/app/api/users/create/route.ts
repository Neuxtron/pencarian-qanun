import db from "../../../db"
import bcrypt from "bcrypt"

export async function POST(req: Request) {
  try {
    const { username, password } = await req.json()
  
    if (!username || !password) {
      return Response.json({
        status: false,
        message: "Username dan password tidak boleh kosong",
        data: {}
      }, { status: 400 })
    }
  
    if (password.length < 8) {
      return Response.json({
        status: false,
        message: "Password minimal 8 karakter",
        data: {}
      }, { status: 400 })
    }
    
    const existing = await db.users.findFirst({ where: { username } })
    if (existing) {
      return Response.json({
        status: false,
        message: "Username sudah diambil",
        data: {}
      }, { status: 403 })
    }

    const saltRounds = parseInt(process.env.SALT_ROUNDS ?? "10")
    const hashedPassword = await bcrypt.hash(password, saltRounds)
    await db.users.create({
      data: {
        username,
        password: hashedPassword
      }
    })
  
    return Response.json({
      status: true,
      message: "Berhasil menambahkan user",
      data: { username, password }
    }, { status: 201 })
  } catch (error) {
    console.log(error)
    return Response.json({
      status: false,
      message: "Terjadi kesalahan",
      data: {}
    }, { status: 500 })
  }
}