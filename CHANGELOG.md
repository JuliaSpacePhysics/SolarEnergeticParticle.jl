# Changelog

## [Unreleased]

The package is analysis-only and works on any TimeseriesUtilities 0.3 container.

### Changed

- **Breaking**: `find_onset(x, (t0, t1))` finds an onset per channel, returning `(; time, N, bg_mean, bg_std)` for a vector or an array of them; it returned `(; onset_time, bg_timerange, bg_mean, bg_std)` for one channel.
- **Breaking**: `find_onset` searches after the background interval rather than from its last sample.
- **Breaking**: the onset method is the first argument of `find_onset` and `vda`, `CUSUM(; n, k, h)` (default) or `NSigma(; n)` or any `f(bg, I)` returning the warning samples, replacing the method keywords.
- **Breaking**: `vda` takes energies in MeV (plain numbers); from a time series, channel energies come from the channel coordinate's `UNITS`, or the `energies` keyword.
- CUSUM and sigma detection skip NaN samples, and the onset is the last finite sample before the warnings.

### Removed

- **Breaking**: data loading (`get_data`, `get_datasets`) and the Speasy dependency; load data with CDAWeb.jl, e.g. `cda"SOHO_ERNE-HED_L2-1MIN/PH"(t0, t1)`.
- **Breaking**: `select_channel`; view the variable (`@view x[1:4:end, :]`), which keeps its coordinates and labels.
- **Breaking**: `find_peak`; use TimeseriesUtilities' `targmax` and `tmaximum`.
- **Breaking**: `vda_stat`, `DatasetInfo`.
