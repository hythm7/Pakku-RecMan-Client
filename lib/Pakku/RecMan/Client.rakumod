use Retry;
use URI::Encode;
use LibCurl::Easy;

use Pakku::Spec;


unit class Pakku::RecMan::Client;

has $!curl = LibCurl::Easy.new;

has @!url is required is built;

method recommend ( ::?CLASS:D: Pakku::Spec:D :$spec!, :$count ) {

  my $query = '/recommend';

  $query ~= '?name='  ~ $spec.name;
  $query ~= '&ver='   ~ $_  with $spec.ver;
  $query ~= '&auth='  ~ $_  with $spec.auth;
  $query ~= '&api='   ~ $_  with $spec.api;
  $query ~= '&count=' ~ $_  with $count;

  $query = uri_encode $query;

  my $meta;
 
  @!url.map( -> $url {

    $!curl.setopt: URL => $url ~ $query;

    last if $meta = try retry { $!curl.perform.content };

  } );

  return Empty unless $meta;

  Rakudo::Internals::JSON.from-json: $meta;
  
}

method search ( ::?CLASS:D: Pakku::Spec:D :$spec!, :$count = ∞ ) {

  my $query = '/search';

  $query ~= '?name='  ~ $spec.name;
  $query ~= '&count=' ~ $count;
  $query ~= '&ver='   ~ $_  with $spec.ver;
  $query ~= '&auth='  ~ $_  with $spec.auth;
  $query ~= '&api='   ~ $_  with $spec.api;

  $query = uri_encode $query;

  my $meta;
 
  @!url.map( -> $url {

    $!curl.setopt: URL => $url ~ $query;

    last if $meta = try retry { $!curl.perform.content };

  } );

  return Empty unless $meta;

  Rakudo::Internals::JSON.from-json: $meta;
  
}


method fetch ( Str:D :url( :$URL )!, Str:D :$download! ) {

  retry {

    $!curl.setopt: :$URL :$download :followlocation;

    $!curl.perform;

  }

}
