package Acme::Zenra;
use strict;
use warnings;
use Carp;
use URI;
use LWP::UserAgent;
use XML::Simple;
use Encode;
use utf8;

our $VERSION = '0.01';

sub new {
    my ( $class, %args ) = @_;
    Carp::croak('yahoo_apppid is needed!') unless defined $args{yahoo_appid};
    my $base_url = $args{yahoo_base_url}
      || 'http://jlp.yahooapis.jp/MAService/V1/parse';
    my $self = {
        appid    => $args{yahoo_appid},
        base_url => $base_url,
        position => $args{position} || '動詞',
        text     => $args{text} || '全裸で',
        ua       => LWP::UserAgent->new
    };
    return bless $self, $class;
}

sub zenrize {
    my ( $self, $sentence ) = @_;
    Carp::croak 'Japanese sentece is needed!' unless $sentence;
    my $uri = URI->new( $self->{base_url} );
    $uri->query_form( appid => $self->{appid}, sentence => $sentence );
    my $res = $self->{ua}->get($uri);
    Carp::croak $res->status_line if $res->is_error;
    my $ref = XMLin( $res->content );
    return $sentence unless ref $ref->{ma_result}{word_list}{word} eq 'ARRAY';
    my $result = '';

    for my $word ( @{ $ref->{ma_result}{word_list}{word} } ) {
        if ( $word->{pos} eq $self->{position} ) {
            $result .= $self->{text};
        }
        $result .= $word->{surface};
    }
    return $result;
}

1;

__END__

=encoding utf8

=head1 NAME

Acme::Zenra - zenrize Japanese text with Yahoo API.

=head1 SYNOPSIS

  use Acme::Zenra;
  use utf8;

  my $zenra = Acme::Zenra->new( yahoo_appid => $ENV{YAHOO_APPID} );
  my $result = $zenra->zenrize('庭には二羽にわとりがいる');
  print encode_utf8( $result ) # 庭には二羽にわとりが全裸でいる

If you want to zenrize as 'nightize'.

  my $zenra = Acme::Zenra->new(
      yahoo_appid => $ENV{YAHOO_APPID},
      position    => '名詞',
      text        => '夜の'
  );
  my $result = $zenra->zenrize('お腹が空いたのでスパゲッティが食べたい');
  print encode_utf8($result)    # 夜のお腹が空いたので夜のスパゲッティが食べたい

=head1 DESCRIPTION

Acme::Zenra is API to zenrize Japanese text using Yahoo API.
To use Acme::Zenra, you need Yahoo API APPID.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

http://developer.yahoo.co.jp/webapi/jlp/ma/v1/parse.html

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
