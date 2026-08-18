use strict;
use warnings;

use Config::Model;

use Config::Model::Tester::Setup qw/init_test setup_test_dir/;
use Path::Tiny;
use 5.10.0;

use Test::More;
use Test::Exception;
# use Test::LongString;
use Test::Log::Log4perl;


use lib "../lib";

use Config::Model::Dpkg::Lintian::Overrides;

subtest "load of tag data from lintian files" => sub {
    ok(Config::Model::Dpkg::Lintian::Overrides::_exists('binary-in-etc'),
       "check known tag");

    ok(! Config::Model::Dpkg::Lintian::Overrides::_exists('shlib-calls-exit'),
       "check unknown tag");

    my %replaced = (
        maintainer => 'mail-contact',
        uploader => 'mail-contact',
        'shlib-calls-exit' => 'exit-in-shared-library',
    );

    while (my ($key,$value) = each %replaced) {
        is(Config::Model::Dpkg::Lintian::Overrides::_new_name($key),
           $value, "check renamed tag ($key)");
    }
};

my $model = Config::Model->new ;
$model ->create_config_class (
    name => "TestClass",
    element => [
        'lintian-overrides' => {
            'type'       => 'leaf',
            'value_type' => 'string',
            class => 'Config::Model::Dpkg::Lintian::Overrides',
        },
    ],
) ;

my $inst = $model->instance(root_class_name => 'TestClass' );

my $root = $inst->config_root ;

subtest "load tag with obsolete value" => sub {
    my $xp = Test::Log::Log4perl->expect(
        ignore_priority => "info",
        ['User', warn =>  qr/Obsolete shlib-calls-exit tag/]
    );
    $root->load(q!lintian-overrides="libburn4 binary: shlib-calls-exit\n"!);
};

$inst->initial_load_stop;

subtest "fix and check change notification" => sub {
    $inst->apply_fixes;
    is( $inst->needs_save, 1, "verify instance needs_save after tag fix" );
    is(
        $root->grab_value(q!lintian-overrides!),
        "libburn4 binary: exit-in-shared-library\n",
        "check tag replacement"
    );
};

done_testing();
