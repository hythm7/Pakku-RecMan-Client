NAME
====
`Pakku::RecMan::Client` - Pakku RecMan Client

SYNOPSIS
========
```raku
use Pakku::RecMan::Client;

my @url = recman.p6c.org, recman.cpan.org;

my $recman = Pakku::RecMan::Client.new: :@url;

# returns meta of distribution matching Pakku::Spec
$recman.recommend: :$spec;

# list distributions matching specs
$recman.list: :@spec;
```

```
# also can use recman-client.raku:
recman-client.raku JSON::Fast recman.pakku.org
```

DESCRIPTION
===========
`Pakku::RecMan::Client` queries a  list of `Pakku::RecMan`s and returns the first answer.

INSTALLATION
===========
```
pakku add Pakku::RecMan::Client

# or 

zef install Pakku::RecMan::Client
```

AUTHOR
======
Haytham Elganiny <elganiny.haytham@gmail.com>

COPYRIGHT AND LICENSE
=====================
Copyright 2020 Haytham Elganiny

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
