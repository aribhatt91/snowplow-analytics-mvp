"use client";
import { useEffect } from "react";
import SnowplowTracker from "@/lib/analytics/tracker";

function SnowplowAnalytics() {
    useEffect(() => {
        console.log("Initializing Snowplow analytics");
        const tracker = SnowplowTracker.getInstance();
        tracker.trackPageView();
    }, []);
    return null;
}

export default SnowplowAnalytics;
