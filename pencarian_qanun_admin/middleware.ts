import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server"

async function isLoggedIn() {
  const cookieStore = await cookies();
  const token = cookieStore.get("TOKEN");
  if (token) return true
  return false
}


export async function middleware(request: NextRequest) {
  if (!(await isLoggedIn())) {
    return NextResponse.redirect(new URL('/login', request.url))
  }
}

export const config = {
  matcher: [
    '/((?!api|login|_next/static|_next/image|favicon.ico).*)',
  ],
}