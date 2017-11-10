#!/usr/bin/perl

use strict;
use warnings;

use Learn::Schema;

my $schema = Learn::Schema->connect( 'dbi:Pg:dbname=dbtodo', 'postgres', 'eokoebrz' );

my @users = $schema->resultset('User')->all;

foreach my $user (@users) {
    $user->password('mypass');
    $user->update;
}
