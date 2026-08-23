package com.securejdk.proffer;

import java.util.List;

public record UnitSpectrum(List<SpectrumCell> cells, int variants, double medianResolution) {
    public UnitSpectrum { cells = List.copyOf(cells); }
}
