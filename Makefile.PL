use 5.006;
use ModPerl::MM ();
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

ModPerl::MM::WriteMakefile(
    NAME              => 'Apache2::ModBT',
    VERSION_FROM      => 'lib/Apache2/ModBT.pm', # finds $VERSION
    PREREQ_PM         => { "Net::BitTorrent::LibBTT" => "0.016" }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Apache2/ModBT.pm', # retrieve abstract from module
       AUTHOR         => 'Tyler \'Crackerjack\' MacDonald <tyler@yi.org>') : ()),
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    LIBS              => join(" ", "-lbttracker", ModPerl::MM::get_def_opt('LIBS')),
);
