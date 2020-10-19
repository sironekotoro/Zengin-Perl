requires 'Encode';
requires 'File::Share', '0.25';
requires 'File::Slurp', '9999.32';
requires 'JSON', '4.01';
requires 'Mouse', 'v2.5.10';
requires 'Mouse::Util::TypeConstraints';
requires 'Smart::Args', '0.14';
requires 'perl', '5.014';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::Fatal', '0.016';
    requires 'Test::More';
};

on develop => sub {
    requires 'Test::Perl::Critic', '1.04';
    requires 'Test::Perl::Metrics::Lite', '0.2';
};
