#!/usr/bin/perl
use Acme::Zenra;
use AnyEvent;
use AnyEvent::IRC::Client;
use Encode;
use utf8;

my $channel = $ARGV[0]          or die 'channel name is needed!';
my $appid   = $ENV{YAHOO_APPID} or die 'set $ENV{YAHOO_APPID}';
my $zenra = Acme::Zenra->new( yahoo_appid => $appid );

my $c   = AnyEvent->condvar;
my $irc = new AnyEvent::IRC::Client;

$irc->reg_cb( connect    => sub { print "connected\n" } );
$irc->reg_cb( registered => sub { print "registered\n"; } );
$irc->reg_cb( disconnect => sub { print "disconnet\n"; } );
$irc->reg_cb(
    publicmsg => sub {
        my ( $irc, $chan, $msg ) = @_;
        my $message = decode_utf8( $msg->{params}->[1] );
        my $result = $zenra->zenrize( $message );
        if ($message ne $result ) {
            $message = encode_utf8(
                '「' . $result . '」ですね。わかります' );
            $irc->send_chan( $channel, "NOTICE", $channel, $message );
        }
    }
);
$irc->connect( "chat.freenode.net", 6667, { nick => 'zenra_bot' } );
$irc->send_srv( "JOIN", $channel );
$c->recv;
