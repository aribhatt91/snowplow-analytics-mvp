"use client";

import { newTracker, trackPageView } from "@snowplow/browser-tracker";

class SnowplowTracker {
    private static instance: SnowplowTracker;

    private constructor() {
        const collectorUrl =
            process.env.NEXT_PUBLIC_SNOWPLOW_COLLECTOR_ENDPOINT;

        if (!collectorUrl) {
            console.error("Snowplow collector URL is not configured");

            return;
        }

        newTracker("sp", collectorUrl, {
            appId: "snowplow-mvp",
        });

        console.log("Snowplow tracker initialized:", collectorUrl);
    }

    public static getInstance(): SnowplowTracker {
        if (!SnowplowTracker.instance) {
            SnowplowTracker.instance = new SnowplowTracker();
        }

        return SnowplowTracker.instance;
    }

    public trackPageView() {
        if (!SnowplowTracker.instance) {
            console.warn("SnowplowTracker instance is not initialized");
            return;
        }
        trackPageView();
    }
}

export default SnowplowTracker;
