#include "mod_perl.h"
#include "modperl_xs_typedefs.h"


#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#undef PERL_UNUSED_DECL
#include "ppport.h"
#include <libbttracker.h>
#include <apache2/mod_bt.h>
#include <apr.h>
#include <apr_strings.h>
#include <apr_hash.h>
#include <apr_general.h>
#include <apr_portable.h>
#include <apr_lib.h>
#include <apr_user.h>
#include "httpd.h"
#include "http_config.h"
#include "http_log.h"
#include "http_request.h"
#include "http_protocol.h"
#include "http_core.h"
#include "util_filter.h"
#include "mpm.h"
#include "apr_dbm.h"
#include "apr_optional.h"
#define APR_WANT_STRFUNC
#include "apr_want.h"
#include "apr_signal.h"
#include "apr_pools.h"

MODULE = Apache2::ModBT		PACKAGE = Apache2::ModBT

Net::BitTorrent::LibBT::Tracker
ModBT_Tracker(server)
	Apache2::ServerRec server
	
	CODE:
	btt_perltracker *rv;
	modbt_config_t *cfg = ap_get_module_config(server->module_config, &bt_module);

	New(0, rv, 1, btt_perltracker);
	
    if(cfg->enabled) {
        apr_pool_create(&rv->p, cfg->tracker->p);
        rv->master = -1;
        rv->tracker = cfg->tracker;

        RETVAL = (Net__BitTorrent__LibBT__Tracker) rv;
    } else {
        XSRETURN_UNDEF;
    }
	
	OUTPUT:
	RETVAL
