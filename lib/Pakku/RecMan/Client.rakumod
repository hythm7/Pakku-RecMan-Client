use Retry;
use LibCurl::Easy;

use Pakku::Spec;


unit class Pakku::RecMan::Client;

has @!url;
has $!curl;

submethod BUILD ( :@url! ) {

  @!url  = @url.map( -> $url { $url ~ '/meta'} );

  $!curl = LibCurl::Easy.new;

}


method recommend ( ::?CLASS:D: Pakku::Spec:D :$spec! ) {

  my $query;

  $query ~= '?name=' ~ $spec.name;
  $query ~= '&ver='  ~ $spec.ver   if $spec.ver;
  $query ~= '&auth=' ~ $spec.auth  if $spec.auth;
  $query ~= '&api='  ~ $spec.api   if $spec.api;

  my $meta;
 
  @!url.map( -> $url {

    $!curl.setopt: URL => $url ~ $query;

    last if $meta = try retry { $!curl.perform.content };

  } );

  return Empty unless $meta;

  $meta;
  
}

multi method list ( ::?CLASS:D: :@spec where *.so ) {

  @spec.map( -> $spec { self.recommend: :$spec } );

}

multi method list ( ::?CLASS:D: :@spec where not *.so ) {


  @!url.map( -> $url {
    $!curl.setopt: URL => "$url/42";
    | try retry { Rakudo::Internals::JSON.from-json: $!curl.perform.content }
  } ).grep( *.defined );

}
