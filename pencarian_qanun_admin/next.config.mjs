/** @type {import('next').NextConfig} */
const maxSize = process.env.NEXT_PUBLIC_MAX_QANUN_SIZE
const nextConfig = {
    experimental: {
        serverActions: {
            bodySizeLimit: `${maxSize}mb`
        }
    }
};

export default nextConfig;
