package com.securejdk.proffer;

import java.util.List;

public final class MetrologyTimeline {
    public List<MetrologyEpoch> epochs() {
        return List.of(
            new MetrologyEpoch(1751, "pre-SI historical baseline", "Context anchor; not an SI definition."),
            new MetrologyEpoch(1799, "metric prototype", "Meter represented by a platinum artifact."),
            new MetrologyEpoch(1875, "Metre Convention", "International measurement cooperation established."),
            new MetrologyEpoch(1889, "international prototype metre", "Platinum-iridium prototype adopted."),
            new MetrologyEpoch(1927, "interferometric realization", "Optical wavelength methods materially improved precision."),
            new MetrologyEpoch(1951, "mercury-198 wavelength work", "NIST historical milestone for wavelength-based realization.")
        );
    }
}
