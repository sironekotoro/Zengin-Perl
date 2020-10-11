use Test::More 0.98;
eval "use Test::Pod::Coverage 1.10";
plan skip_all => "Test::Pod::Coverage 1.10 required for testing POD coverage"
   if $@;
all_pod_coverage_ok();