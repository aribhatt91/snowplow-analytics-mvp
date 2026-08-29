import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import SnowplowAnalytics from "@/components/layouts/SnowplowAnalytics";
import "./globals.css";

const geistSans = Geist({
    variable: "--font-geist-sans",
    subsets: ["latin"],
});

const geistMono = Geist_Mono({
    variable: "--font-geist-mono",
    subsets: ["latin"],
});

export const metadata: Metadata = {
    title: "Snowplow MVP",
    description: "A minimal example of using Snowplow",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
    return (
        <html
            lang="en"
            className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
        >
            <SnowplowAnalytics />
            <body className="min-h-full flex flex-col">{children}</body>
        </html>
    );
}
