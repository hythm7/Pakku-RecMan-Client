use Retry;
use URI::Encode;
use LibCurl::Easy;

use Pakku::Spec;


unit class Pakku::RecMan::Client;

has $!curl = LibCurl::Easy.new;

has @.url;

submethod TWEAK ( ) { @!url .= map( -> $url { $url ~ '/recommend' } ) }

method recommend ( ::?CLASS:D: Pakku::Spec:D :$spec!, :$count ) {

  my $query;

  $query ~= '?name='  ~ $spec.name;
  $query ~= '&ver='   ~ $_  with $spec.ver;
  $query ~= '&auth='  ~ $_  with $spec.auth;
  $query ~= '&api='   ~ $_  with $spec.api;
  $query ~= '&count=' ~ $_  with $count;

  $query = uri_encode $query;

  my $meta;
 
  @!url.map( -> $url {

    $!curl.setopt: URL => $url ~ $query;

    last if $meta = try retry { Rakudo::Internals::JSON.from-json: $!curl.perform.content };

  } );

  return Empty unless $meta;

  $meta;
  
}

method fetch ( Str:D :$URL!, Str:D :$download! ) {

  retry {

    $!curl.setopt: URL => ~$URL, :$download, :followlocation;

    $!curl.perform;

  }

}
