#!/usr/bin/env raku

use Pakku::RecMan::Client;

multi MAIN ( Str:D  $spec, *@url ) {

  my $recman = Pakku::RecMan::Client.new: :@url;

  my $meta = $recman.recommend: spec => Pakku::Spec.new: $spec;

  say $meta if $meta;

}

multi MAIN ( 'list-all', *@url ) {

  Pakku::RecMan::Client.new( :@url ).list.map( *.say );

}
