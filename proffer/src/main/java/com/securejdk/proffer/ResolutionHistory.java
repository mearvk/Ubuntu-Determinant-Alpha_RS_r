package com.securejdk.proffer;

import java.util.List;

public record ResolutionHistory(int startYear, int endYear, List<ResolutionGradient> gradients) {
    public ResolutionHistory { gradients = List.copyOf(gradients); }
}
