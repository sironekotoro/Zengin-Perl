requires 'Encode';
requires 'File::Share', '0.25';
requires 'File::Slurp', '9999.32';
requires 'Function::Parameters', '2.001003';
requires 'JSON';
requires 'Lingua::JA::Regular::Unicode', '0.13';
requires 'Moo', '2.004004';
requires 'parent';
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
};
