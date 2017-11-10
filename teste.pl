use utf8;
use DDP;
use JSON::MaybeXS;
use File::Slurp;
use Data::Dumper;

my $filename = "teste.json";
my $text     = read_file($filename);
p $text;

my $json_output = decode_json($text);

p $json_output;
print Dumper($json_output);
