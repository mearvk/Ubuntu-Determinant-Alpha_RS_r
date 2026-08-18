package Config::Model::Dpkg::Copyright::License;

use 5.20.0;

use Mouse;
extends qw/Config::Model::HashId/;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

use Scalar::Util qw/weaken/;
use Log::Log4perl qw(get_logger :levels);

my $user_logger = get_logger('User');

# checkUnused license is a idx check, not a content check

sub BUILD ($self, @args) {
    $self->SUPER::BUILD(@args);

    weaken($self);
    $self-> add_check_content( sub { $self->check_unused_licenses(@_);} );
    return;
}

sub check_idx { ## no critic (RequireArgUnpacking)
    my $self = shift;
    my %args      = @_ > 1 ? @_ : ( index => $_[0] );

    my $idx       = $args{index};
    my $silent    = $args{silent} || 0;
    my $check     = $args{check} || 'yes';
    my $apply_fix = $args{fix} // $check eq 'fix' ? 1 : 0;

    my $has_error =  $self->SUPER::check_idx(%args);

    return $has_error if $self->instance->initial_load;
    # not called after initial load if idx os not modified... is that a global check ?

    my $unused_licenses = $self->_get_unused_licenses($idx);
    if ($check eq 'yes' and $unused_licenses->{$idx}) {
        if ($apply_fix) {
            say "Deleting unused $idx license" unless $silent;
            $self->delete($idx);
        }
        else {
            $self->{warning_hash}{$idx} //= [];
            my $warn = "License $idx is not used in Files: section";;
            $self->inc_fixes;
            push $self->{warning_hash}{$idx}->@*, $warn;
            $user_logger->warn("$warn") unless $silent;
        }
    }


    return $has_error;
}

# TODO: move global check from Copyright to here ?

sub _get_unused_licenses ($self, @licenses) {
    my @to_check = scalar @licenses ? @licenses : $self->fetch_all_indexes;

    my %unused = map { $_ => 1 } @to_check;
    foreach my $path ($self->grab('- Files')->fetch_all_indexes) {
        my $lic = $self->grab(qq!- Files:"$path" License!);
        next if $lic->fetch_element_value("full_license"); # no need of a global License

        my $names = $lic->fetch_element_value(name => "short_name", check => "no") ;

        next unless $names; # may be undef when user is filling values

        my @sub_licenses = split m![,\s]+(?:or|and|and/or)[,\s]+!,$names;
        map { delete $unused{$_}; } @sub_licenses;
    }

    return \%unused;
}

sub check_unused_licenses ($self,$error, $warn, $fix = 0, $silent = 0) {

    if ($fix) {
        return $self->prune_unused_licenses($silent);
    }

    my @unused = sort keys $self->_get_unused_licenses()->%*;

    return unless @unused;

    my $msg =  "Unused license: @unused";
    push $warn->@*, $msg;
    return;
}

sub prune_unused_licenses ($self, $silent = 0) {

    my @unused = sort keys $self->_get_unused_licenses()->%*;

    return unless @unused;

    say "Deleting unused license: @unused" unless $silent;
    foreach my $lic (@unused) {
        $self->delete("$lic");
    }
    return;
}
1;
