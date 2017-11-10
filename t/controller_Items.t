use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Learn';
use Learn::Controller::Items;

ok( request('/items')->is_redirect, 'Request should succeed' );
done_testing();
