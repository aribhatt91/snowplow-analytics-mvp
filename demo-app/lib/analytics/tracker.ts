"use client";

import { newTracker, trackPageView } from "@snowplow/browser-tracker";

let initialized = false;

/**
 * Initialise the Snowplow tracker.
 *
 * This function is safe to call multiple times.
 * The tracker will only be created once.
 */
export function initializeSnowplow() {
    if (initialized) {
        return;
    }

    const collectorUrl = process.env.NEXT_PUBLIC_SNOWPLOW_COLLECTOR_ENDPOINT;

    if (!collectorUrl) {
        console.error("Snowplow collector URL is not configured");

        return;
    }

    newTracker("sp", collectorUrl, {
        appId: "snowplow-mvp",
    });

    initialized = true;

    console.log("Snowplow tracker initialized:", collectorUrl);
}

/**
 * Track a Snowplow page view.
 */
export function trackSnowplowPageView() {
    if (!initialized) {
        console.warn("Snowplow has not been initialized");

        return;
    }

    trackPageView();
}
