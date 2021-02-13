use Retry;
use URI::Encode;
use LibCurl::Easy;

use Pakku::Spec;


unit class Pakku::RecMan::Client;

has $!curl;

has @.url;


submethod BUILD ( :@url ) {

  $!curl = LibCurl::Easy.new;

  @!url  = @url.map( -> $url { $url ~ '/meta'} );

}


method recommend ( ::?CLASS:D: Pakku::Spec:D :$spec! ) {

  my $query;

  $query ~= '?name=' ~ $spec.name;
  $query ~= '&ver='  ~ $_  with $spec.ver;
  $query ~= '&auth=' ~ $_  with $spec.auth;
  $query ~= '&api='  ~ $_  with $spec.api;

  $query = uri_encode $query;

  my $meta;
 
  @!url.map( -> $url {

    $!curl.setopt: URL => $url ~ $query;

    last if $meta = try retry { $!curl.perform.content };

  } );

  return Empty unless $meta;

  $meta;
  
}

method fetch ( Str:D :$URL!, Str:D :$download! ) {

  retry {

    $!curl.setopt: URL => ~$URL, :$download;

    $!curl.perform;

  }

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
