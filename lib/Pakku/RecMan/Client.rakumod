use LibCurl::HTTP :subs;

use Pakku::Spec;


unit class Pakku::RecMan::Client;

has @!url;

submethod BUILD ( :@url! ) {

  @!url = @url.map( -> $url { $url ~ '/meta'} );

}


method recommend ( ::?CLASS:D: Pakku::Spec:D :$spec! ) {

  my $query;

  $query ~= '?name=' ~ $spec.name;
  $query ~= '&ver='  ~ $spec.ver   if $spec.ver;
  $query ~= '&auth=' ~ $spec.auth  if $spec.auth;
  $query ~= '&api='  ~ $spec.api   if $spec.api;

  my $meta;
 
  @!url.map( -> $url { last if $meta = jget $url ~ $query } );

  return Empty unless $meta;

  $meta;
  
}

multi method list ( ::?CLASS:D: :@spec where *.so ) {

  @spec.map( -> $spec { self.recommend: :$spec } );

}

multi method list ( ::?CLASS:D: :@spec where not *.so ) {

  flat @!url.map( -> $url { jget "$url/42"  } );

}
