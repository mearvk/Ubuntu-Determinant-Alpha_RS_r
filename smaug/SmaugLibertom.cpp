#include "SmaugLibertom.hpp"
#include <algorithm>

namespace smaug::libertom {
namespace {

double clamp_value(double value) noexcept {
    return std::clamp(value, kBaseLibertom, kPeakLibertom);
}

} // namespace

LibertomState normalize(LibertomState state) {
    state.value = clamp_value(state.value);
    state.scales.careful = clamp_value(state.scales.careful);
    state.scales.reciprocal = clamp_value(state.scales.reciprocal);
    state.reeducation = std::clamp(state.reeducation, 0.0, 1.0);
    return state;
}

LibertomDecision choose_elevation(LibertomState state, double reeducation_score) {
    state.reeducation = std::clamp(reeducation_score, 0.0, 1.0);
    state = normalize(state);

    LibertomDecision result;
    result.state = state;
    if (!state.graduated || state.die_events < kGraduationDieEvents) {
        result.state.elevation = Elevation::Hold;
        result.reason = "Graduation threshold has not been reached";
        return result;
    }

    if (state.reeducation < 0.90) {
        result.state.elevation = Elevation::Consider;
        result.reason = "Reeducation evidence is below the elevation threshold";
        return result;
    }

    result.state.elevation = Elevation::Elevate;
    result.permitted = true;
    result.reason = "Reeducation evidence permits a bounded elevation choice";
    return result;
}

LibertomState refold(LibertomState state, Special3D special) {
    state = normalize(state);
    const double delta = 0.005;
    switch (special) {
        case Special3D::TradingTechnology:
            state.scales.careful = clamp_value(state.scales.careful + delta);
            break;
        case Special3D::Law:
            state.scales.reciprocal = clamp_value(state.scales.reciprocal + delta);
            break;
        case Special3D::Scaffold:
            state.scales.careful = clamp_value((state.scales.careful + state.value) / 2.0);
            break;
        case Special3D::Mirror:
            state.scales.reciprocal = clamp_value((state.scales.reciprocal + state.scales.careful) / 2.0);
            break;
    }
    state.value = clamp_value((state.scales.careful + state.scales.reciprocal) / 2.0);
    return state;
}

} // namespace smaug::libertom
