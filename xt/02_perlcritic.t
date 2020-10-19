use strict;
use Test::More;
use Test::Perl::Critic 1.04;

eval {
    Test::Perl::Critic->import( -severity => 5 );

};
plan skip_all => "Test::Perl::Critic is not installed." if $@;

all_critic_ok("lib", "t");
