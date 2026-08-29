"use client";
import { useEffect } from "react";
import {
    initializeSnowplow,
    trackSnowplowPageView,
} from "@/lib/analytics/tracker";

function SnowplowAnalytics() {
    useEffect(() => {
        console.log("Initializing Snowplow analytics");
        initializeSnowplow();
        trackSnowplowPageView();
    }, []);
    return null;
}

export default SnowplowAnalytics;
