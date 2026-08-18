package Config::Model::Backend::DpkgStoreRole ;

use strict;
use warnings;
use Mouse::Role;

use Carp;
use Config::Model::Exception ;
use Log::Log4perl qw(get_logger :levels);
use 5.20.0;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

# push data on list, does not clear
sub store_section_list_element ($self, $logger, $list_obj, $check, $v_ref) {
    # v_ref is a list of ($value, $line_nb ,$note,@comment)

    my $idx = $list_obj->fetch_size;
    my @list_comment;
    foreach my $v_info ( $v_ref->@* ) {
        if (ref $v_info) {
            my ($v,$l,$note,@c) = @$v_info;
            # $v can be '    foo,' ' , foo' or 'foo, bar, baz'. This depends on input format
            # there can only be one comment for all these values (constrained by syntax)
            $v =~ s/\s*,\s*$//;
            $v =~ s/^[\s,]+//;
            my @items = split /\s*,\s*/, $v;
            my $comment = join("\n", @c);
            my $item_idx = 0;

            foreach my $item (@items) {
                $logger->debug( "list store $idx:'$item'" . ($comment ? " comment '$comment'" : ''));
                my $elt_obj = $list_obj->fetch_with_id($idx++);
                $elt_obj->store( $item, check => $check );
                $elt_obj->annotation($comment) if $comment and $item_idx++ == 0;
                $elt_obj->notify_change(note => $note, really => 1) if $note ;
            }
        }
        else {
            push @list_comment, $v_info if $v_info;
        }
    }
    $list_obj->annotation(@list_comment) if @list_comment;
    return;
}

sub store_section_leaf_element ($self, $logger, $elt_obj, $check, $v_ref) {
    # v_ref is a list of (@comment , [ value, $line_nb ,$note ] )
    my $value_type = $elt_obj->value_type;

    my (@v,@comment,@note);
    foreach my $v_item ( $v_ref ->@* ) {
        if (ref $v_item) {
            push @v, $v_item->[0] if $value_type eq 'string' or $v_item->[0] =~ /\S/;
            push @note, $v_item->[2] if $v_item->[2];
        }
        elsif ($v_item) {
            push @comment, $v_item;
        }
    }

    my $v = join("\n", @v);
    if (@v > 1 and $value_type ne 'string') {
        my $elt_name = $elt_obj->element_name;
        $logger->warn($elt_name, " should be only one line. Gluing together the lines");
        $v = join(" ", @v);
        $elt_obj->notify_change(
            note => "Gluing together lines",
            really => 1,
        );
    }
    my $note = join("\n", @note);

    $logger->debug("storing ",$elt_obj->element_name," value: $v");
    $elt_obj->store( value => $v, check => $check );
    $elt_obj->annotation(@comment) if @comment ;
    $elt_obj->notify_change(note => $note, really => 1) if $note ;
    return;
}

1;
