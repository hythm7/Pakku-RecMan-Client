#!/usr/bin/env raku

use Pakku::RecMan::Client;

unit sub MAIN ( Str:D  :$spec!, :$count, *@url ) {

  my $recman = Pakku::RecMan::Client.new: :@url;

  my $meta = $recman.recommend: :$count, spec => Pakku::Spec.new: $spec;

  say $meta if $meta;

}
