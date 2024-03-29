package Apache2::ModBT;

use 5.006;
use strict;
use warnings;
use Net::BitTorrent::LibBTT;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Apache::ModBT ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.018';

require XSLoader;
XSLoader::load('Apache2::ModBT', $VERSION);

# Preloaded methods go here.

1;
__END__

=head1 NAME

Apache2::ModBT - mod_perl interface to mod_bt

=head1 SYNOPSIS

  use Apache2::ModBT;

  sub handler
  {
   my $r = shift;
   my $tracker = $r->server->ModBT_Tracker();
   print $tracker->num_peers, "\n";
   foreach my $i ($tracker->Infohashes())
   {
   	...
   }
  }

=head1 DESCRIPTION

This is a pole for perl.

The Apache2::ModBT module adds a method onto the Apache::Server object
which returns the LibBTT Tracker object for the current mod_bt process.
When manipulating a mod_bt tracker from within Apache2, you should use
this method instead of calling Net::BitTorrent::LibBTT->new().

=over

=item $r->server->ModBT_Tracker()

Returns a tracker object that corresponds to the mod_bt tracker instance
running on the current apache process. If the tracker is not enabled
("Tracker On" is not set in httpd.conf), this will return C<undef>.

=head1 SEE ALSO

L<Net::BitTorrent::LibBTT>, L<http://www.crackerjack.net/mod_bt/>, L<http://perl.apache.org/>

=head1 AUTHOR

Tyler 'Crackerjack' MacDonald, <tyler@yi.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Tyler 'Crackerjack' MacDonald

This library is free software; you can redistribute it and/or modify
it under the terms of the Apache License 2.x
(L<http://www.apache.org/licenses/LICENSE-2.0>).

=cut
