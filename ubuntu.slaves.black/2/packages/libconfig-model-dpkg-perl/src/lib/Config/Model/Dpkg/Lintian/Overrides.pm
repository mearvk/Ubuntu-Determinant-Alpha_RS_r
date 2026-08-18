package Config::Model::Dpkg::Lintian::Overrides;

use strict;
use warnings;
use Mouse;
use Path::Tiny;
use Log::Log4perl qw(get_logger :levels);
use Parse::DebControl;

use 5.20.1;

extends qw/Config::Model::Value/ ;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

my $logger = get_logger("Backend::Dpkg::Lintian");
my $user_logger = get_logger('User');

# read all tag files and construct a list of valid tags
# and a list of replacements tag

my %tags;
my %renames;

my $tag_dir = path('/usr/share/lintian/tags');
my $parser = Parse::DebControl->new;

if ($tag_dir->is_dir) {
    $tag_dir->visit(
        sub {
            my ($path, $state) = @_;
            return unless $path =~ /\.tag$/;

            my $data = $parser->parse_file($path->stringify, {stripComments => 1});
            my $hash = $data->[0];
            $tags{ $hash->{Tag} }=1;

            if ($hash->{'Renamed-From'}) {
                my @rnf = grep { /\w/} split /[\s\n]+/, $hash->{'Renamed-From'};
                foreach my $old_name ( @rnf ) {
                    $renames{$old_name} = $hash->{Tag};
                }
            }
        },
        { recurse => 1 }
    )
}

sub _exists ($tag) {
    return $tags{$tag};
}

sub _new_name ($tag) {
    return $renames{$tag};
}

around _check_value => sub ( $orig, $self, %args ) {
    my $quiet     = $args{quiet} || 0;
    my $check     = $args{check} || 'yes';
    my $apply_fix = $args{fix} || 0;
    my $mode      = $args{mode} || 'backend';

    $logger->info("around _check_value called for ".$self->location, "apply_fix: ", $apply_fix );

    my ($ok, $value, $error, $warn) = $self->$orig( %args );

    return ($ok, $value, $error, $warn) unless $value;

    my @lines = split /\n/, $value;
    foreach my $line (@lines) {
        next if $line =~ /^#/;
        next unless $line =~ /:/;

        # [<package>][ <archlist>][ <type>]: ]<lintian-tag>[ [*]<lintian-context>[*]]
        my ($pkg_arch_type, $tag_context) = split /\s*:\s*/, $line, 2;
        my ($tag, $context) = split /\s+/, $tag_context, 2;

        if ($tag) {
            next if _exists($tag);
            if (my $new = _new_name($tag)) {
                $logger->info("Found old tag $tag, new is $new.");
                push @$warn, "Obsolete $tag tag. New tag is $new";
                if ($apply_fix) {
                    $line =~ s/(:\s*)($tag)/$1$new/;
                    $self->notify_change(
                        old => $tag,
                        new => $new,
                        note => 'update obsolete lintian tag'
                    );
                } else {
                    $self->{nb_of_fixes}++;
                }
            }
            else {
                $logger->info("Found unknown tag $tag.");
                push @$warn, "Unknown $tag tag.";
            }
        }
    }

    my $new_overrides = $self->{data} = join("\n",@lines)."\n";
    return ($ok, $new_overrides, $error, $warn);
};

1;

__END__

=head1 NAME

Config::Model::Dpkg::Lintian::Overrides - Checks lintian-overrides file

=head1 SYNOPSIS

No synopsis. This class is to be used by Dpkg model.

=head1 DESCRIPTION

This class is derived from L<Config::Model::Value>. Its purpose is to
check the content of C<debian/*lintian-overrides> and
C<debian/source/lintian-overrides> files.

Only the validity of the tags are checked. They are compared to the list of tags
shipped in lintian package.

Unknown or obsolete tags trigger a warning.

Obsolete tags can be replaced with their new name with C<cme fix dpkg>.

=head1 Limitations

=over

=item *

Syntax of lintian-overrides is not checked.

=back

=head1 AUTHOR

Dominique Dumont, ddumont [AT] cpan [DOT] org

=head1 SEE ALSO

L<Config::Model>,
L<Config::Model::Value>,
L<lintian>
