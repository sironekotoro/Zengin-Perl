# Data flow and CI

Bank and branch data flow in one direction:

`zengin-code/source-data` → `Zengin-Perl/share/data` → Perl consumers.

The scheduled workflow checks out the upstream data with no persisted credentials, runs the tests, and only then commits `share/data` and the matching date in `lib/Zengin/Perl.pm` to this repository's `master` branch. It does not modify the upstream source. Pushes to `dev` and pull requests only run checks; they cannot publish data. The source dataset is not edited here: corrections belong in `zengin-code/source-data`.

The `complexity` job measures Perl functions in `lib/` with cccc. It reports the most complex functions on pull requests and `dev` pushes. The first adoption records a baseline without a numeric failure threshold; after reviewing the measured values, add a threshold without forcing an unrelated refactor.

Dependabot monitors GitHub Actions weekly. Perl dependencies in `cpanfile` are outside Dependabot's supported ecosystems and are reviewed separately.
