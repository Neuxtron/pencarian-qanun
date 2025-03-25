/** @type {import('next').NextConfig} */
const maxSize = process.env.NEXT_PUBLIC_MAX_QANUN_SIZE;
const nextConfig = {
  experimental: {
    serverActions: {
      bodySizeLimit: `${maxSize}mb`,
    },
  },
  async headers() {
    return [
      {
        source: "/api/:path*",
        headers: [
          { key: "Access-Control-Allow-Origin", value: "*" },
          {
            key: "Access-Control-Allow-Methods",
            value: "GET, POST, PUT, DELETE, OPTIONS",
          },
          {
            key: "Access-Control-Allow-Headers",
            value: "Content-Type, Authorization",
          },
        ],
      },
    ];
  },
};

export default nextConfig;
