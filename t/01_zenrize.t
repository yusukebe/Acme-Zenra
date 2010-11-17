use Test::More;
use strict;
use Encode;
use utf8;

BEGIN {
    plan skip_all => 'set YAHOO_APPID to test'
      unless $ENV{YAHOO_APPID};
    use_ok('Acme::Zenra');
}

my $sentence = '庭には二羽にわとりがいる';
my $zenra = Acme::Zenra->new( yahoo_appid => $ENV{YAHOO_APPID} );
ok($zenra, 'Make instace');
my $result = $zenra->zenrize($sentence);
ok($result, 'Get Result');
isnt( $result, $sentence, 'Zenrize' );
diag encode_utf8($result);

done_testing;
