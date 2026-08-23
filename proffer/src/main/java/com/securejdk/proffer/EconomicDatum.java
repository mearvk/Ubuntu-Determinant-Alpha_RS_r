package com.securejdk.proffer;

public record EconomicDatum(int year, String series, double value, String unit, String source, String confidence) {}
