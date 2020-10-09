requires 'Carp', '1.50';
requires 'File::Share', '0.25';
requires 'File::Spec', '3.74';
requires 'JSON', '4.01';
requires 'Mouse', '2.5';
requires 'perl', '5.014';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};
