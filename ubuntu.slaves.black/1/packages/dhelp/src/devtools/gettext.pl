use Locale::gettext;
use POSIX;

my $gettext = Locale::gettext->domain_raw("dhelp");
$gettext->codeset('UTF-8'); # Always UTF-8, specified in the HTML templates

foreach my $locale (qw(
        de_DE.utf8
        el_GR.utf8
        es_ES.utf8
        eu_ES.utf8
        id_ID.utf8
        ru_RU.utf8
        fr_FR.utf8
    )) {
    setlocale(LC_MESSAGES, $locale);
    my $string = "No search database found.\nPlease run /etc/cron.weekly/dhelp as superuser to create it.";
    print "LOCALE $locale ============================\n";
    print $gettext->get($string), "\n";
}
