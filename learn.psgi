use strict;
use warnings;

use Learn;

my $app = Learn->apply_default_middlewares(Learn->psgi_app);
$app;

