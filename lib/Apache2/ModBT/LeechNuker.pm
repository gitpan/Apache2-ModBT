#!perl

package Apache2::ModBT::LeechNuker;

=pod

=head1 NAME

Apache2::ModBT::LeechNuker - mod_perl handler to shun leeches on a mod_bt BitTorrent Tracker

=head1 SYNOPSIS

	PerlModule Apache2::ModBT::LeechNuker

	<Location "/announce">
		<IfModule mod_perl.c>
			PerlFixupHandler	Apache::ModBT::LeechNuker
			PerlSetVar			MinLeechTime		3600
		</IfModule>
	</Location>

=head1 DESCRIPTION

The Apache::ModBT::LeechNuker module is a basic example on how to manipulate the operations of
a mod_bt BitTorrent tracker from mod_perl.

When run on an "/announce" request, this module will look up the peer making the request in
the tracker's database. If the peer has not uploaded anything, and has been connected to
the tracker for a certain amount of time (the default is 3600 seconds or 1 hour), has been
downloading, and there are other peers that need his or her help, the peer's "Shunned"
flag is set in the database.

A "Shunned" peer is never given any other peers when it makes /announce requests, and is
never served to other peers, effectively blocking the peer from the network 

=head1 SEE ALSO

L<Apache2::ModBT>, L<Net::BitTorrent::LibBTT>, L<http://www.crackerjack.net/mod_bt/>, L<http://perl.apache.org/>

=cut

use strict;
use warnings;

use Apache2::Const qw(DECLINED);
use Apache2::RequestRec;
use Apache2::RequestIO;

use URI;
use Apache2::ModBT;
use Net::BitTorrent::LibBTT;
use URI::Escape;

our $Shunned;

my(%flags)=(reverse(Net::BitTorrent::LibBTT::Peer::Flags()));

if(!$flags{Shunned})
{
 die "This tracker does not have a \"Shunned\" flag!";
}

$Shunned = $flags{Shunned};

our $shunstr =
 "Shunning peer \"%s\" from hash \"%s\" (No up, %u down, %u left, %u online, %u/%u downloaders)\n";

return 1;

sub handler {
 my $r = shift;
 my $uri = URI->new();
 my $leechtime = $r->dir_config("MinLeechTime") || 3600;
 $uri->query($r->args);
 my(%args)=($uri->query_form());
 my $tracker;

 unless($tracker = $r->server->ModBT_Tracker()) {
  # tracker is not enabled
  return DECLINED;
 }     
 
 if($args{"info_hash"} && $args{"peer_id"}) {
  if(my $hash = $tracker->Infohash(uri_unescape($args{"info_hash"}))) {
   if(my $peer = $hash->Peer(uri_unescape($args{"peer_id"}))) {
    if(
     (!$peer->uploaded) && ($peer->downloaded) && ($peer->left) &&
     ($hash->seeds) && ($hash->peers > ($hash->seeds + 1)) &&
     ((time() - $peer->first_t) > $leechtime) &&
     (!($peer->flags & $Shunned))
    ) {
     warn sprintf
     (
      $shunstr, uri_escape($peer->peerid), uri_escape($peer->infohash),
      $peer->downloaded, $peer->left, time() - $peer->first_t, $hash->peers, $hash->seeds
     );
     $peer->flags($peer->flags | $Shunned);
     $peer->save();
    }
   }
  }
 }
 
 return DECLINED;
}
