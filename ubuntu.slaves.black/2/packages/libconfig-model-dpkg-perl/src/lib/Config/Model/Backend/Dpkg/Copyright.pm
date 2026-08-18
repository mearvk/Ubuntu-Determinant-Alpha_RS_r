
package Config::Model::Backend::Dpkg::Copyright ;

use strict;
use warnings;

use Mouse ;

extends 'Config::Model::Backend::Any';

with 'Config::Model::Backend::DpkgSyntax';
with 'Config::Model::Backend::DpkgStoreRole';

use 5.20.1;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

use Carp;
use Config::Model::Exception ;
use Config::Model::ObjTreeScanner ;
use File::Path;
use Log::Log4perl qw(get_logger :levels);

my $logger = get_logger("Backend::Dpkg::Copyright") ;
my $user_logger = get_logger('User');

my %store_dispatch = (
    list    => 'store_section_list_element',
    string  => 'append_text_no_synopsis',
    uniline => 'store_section_leaf_element',
);

sub read ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args is:
    # object     => $obj,         # Config::Model::Node object 
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path 
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf' 
    # check      => yes|no|skip

    my $fp = $args{file_path};

    return 0 unless defined $fp and $fp->is_file ;

    my $check = $args{check} || 'yes';

    $logger->info("Parsing $fp");

    # load dpkgctrl file
    my $c = $self -> parse_dpkg_file ($fp, $check ) ;
    return 0 unless @$c ; # no sections in file

    my $root = $args{object} ;
    my $file;
    my %license_paragraph ;
    my @license_names ;
    my %file_paragraph ;
    my @file_names ;

    # put header aside
    my $header_line_nb = shift @$c ;
    my $header_info    = shift @$c ;

    my $section_nb = 1 ; # header was put aside, so start at 1
    while (@$c) {
        my ($section_line, $section_ref) = splice @$c, 0, 2;
        $section_nb ++ ;
        $logger->info("Classifying section $section_nb found in line $section_line");
        my %h = @$section_ref ;

        # normalise
        my %section = map { (lc($_),$h{$_}) ; } keys %h ;
        $logger->debug("section nb $section_nb has fields: ".join(' ',keys %section)) ;

        # Some people use 'File' to declare copyright info for a single file.
        # While this is correct grammatically, it tends to be PITA
        if (my $file_section = delete $section{file}) {
            $user_logger->warn("copyright line $section_line: section 'File' is converted in 'Files' section (mind the plural)\n");
            $file_section->[0][2] = 'changed file section into files section' ;
            $section{files} //= $file_section ; # no clobber of good section
        }

        if ( defined $section{copyright} and not defined $section{files}
             and not defined $file_paragraph{'*'} 
            ) {
            # Some legacy files can have a header and one paragraph with License tag
            # more often than not, this is an implied "File: *"  section
            my $str = "Missing 'Files:' specification in section starting line $section_line. Use cme with -force option to load.";
            Config::Model::Exception::Syntax 
                -> throw ( object => $self, error => $str, parsed_line => $section_line ) 
                    if $check eq 'yes' ;
            $user_logger->warn("$str Adding 'Files: *' spec\n") ;
            # the 3rd element is used to tell root node that read data was 
            # altered and needs to be written back
            $section{files} = [ ['*', $section_line, 'created missing File:* section' ] ];
        }

        if (defined $section{licence}) {
            $user_logger->warn("copyright line $section_line: Converting UK spelling for license in US spelling\n");
            $section{license} = delete $section{licence} ;# FIXME: use notify_change
            $section{license}[0][2] = 'changed uk spelling for license (was licence)'; # is altered
        }

        if (defined $section{files}) {
            # file_paragragh hash is used to contain file data indexed by file names
            # file names may be extracted from several lines in copyright file
            my @file_keys;
            foreach my $file_item( $section{files}->@* ) {
                my ($v,$l, $a) = $file_item->@*;
                if ($logger->is_debug) {
                    my $a_str = $a ? "altered: '$a' ":'' ;
                    $logger->debug("Found Files paragraph line $l, $a_str($v)");
                }
                if ($v =~ /,/) {
                    $user_logger->warn("Found comma in Files line $l, cleaning up");
                    $v =~ s/,+/ /g;
                }
                $v =~ s/(?<=\w)[ \t]+/ /g; # cleanup spacing between words
                $v =~ s/\s+$//;
                push @file_keys, $v;
            }
            # join with \n to keep original lines
            my $file_key = join("\n", @file_keys);
            $logger->debug("Files paragraph after cleanup: '$file_key'");
            $file_paragraph{$file_key} = $section_ref ;
            push @file_names, $file_key ;
        }
        elsif (defined $section{license}) {
            # license_paragragh hash is used to contain license data indexed by license names
            # license name contains only one line
            my ($v,$l, $author) = $section{license}[0]->@* ;
            # need to extract license name from license text
            my ($lic_name) = ($v =~ /^([^\n]+)/) ;
            if (not defined $lic_name) {
                $lic_name = 'other';
                $author = $section{license}[2] = q!use 'other' to replace undefined license name!;
            }
            if ($logger->is_debug) {
                my $a_str = $author ? "altered: '$author' ":'' ;
                $logger->debug("Found license paragraph line $l, $a_str ($lic_name)");
             }
            $license_paragraph{$lic_name} = $section_ref ;
            push @license_names, $lic_name ;
        }
        else {
            my $str = "Unknown section type beginning at line $section_line. "
                . "Is it a Files or a License section ?";
            if ($check eq 'yes') {
                Config::Model::Exception::Syntax -> throw ( 
                    object => $self, 
                    error => $str, 
                    parsed_line => $section_line 
                );
            }
            $user_logger->warn("copyright line $section_line: Dropping unknown paragraph");
        }
    }

    $logger->info("First pass to read pure license sections from $args{file} control file");

    foreach my $lic_name (@license_names) {
        my $object = $root->grab(step => qq!License:"$lic_name"!, check => $check);

        my $section = $license_paragraph{$lic_name} ;
        for (my $i=0; $i < @$section ; $i += 2 ) {
            my $key = $section->[$i];
            my $v_ref = $section->[$i+1];
            my ($v1,$l1,$a1) = $v_ref->[0]->@*;
            $logger->info("reading key $key from $args{file} file line $l1 altered $a1 for ".$object->name);
            $logger->debug("$key first line value: '$v1'");

            if ($key =~ /licen[sc]e/i) {
                shift $v_ref->@* ; # remove first line that contains $lic_name
                $logger->debug("adding license text for '$lic_name'");

                # lic_obj may not be defined in -force mode
                next unless defined $object ;

                my $elt_obj = $object->fetch_element('text');
                $self-> store_section_leaf_element( $logger, $elt_obj, $check, $v_ref );
            }
            else {
                # store other sections thanks to 'accept' clause
                my $elt_obj = $object->fetch_element($key);
                $self-> store_section_leaf_element( $logger, $elt_obj, $check, $v_ref );
            }
        }
    }   

    $logger->info("Second pass to header section from $args{file} control file");
    my $object = $root ;
   
    my @header = @$header_info ;
    for (my $i=0; $i < @header ; $i += 2 ) {
        my $key = $header[$i];
        my $v_ref = $header[$i+1] ;

        # these represent information from the first line only
        my ($v1,$l1,$a1) = $v_ref->[0]->@*;

        $logger->info("reading key $key from header line $l1 ". ($a1 ? "altered $a1 " :''). "for ".$object->name);
        $logger->debug("$key first line value: '$v1'");

        if ($key =~ /^licen[sc]e$/i) {
            my $lic_node = $root->fetch_element('Global-License') ;
            $self->_store_license_info ($lic_node, $key, $check, $v_ref);
        }
        elsif ( $key eq 'Files' ) {
            die "Error: unexpected 'Files' field in header section of copyright (line $l1). Did you forget the header section?";
        }
        elsif (my $found = $object->find_element($key, case => 'any')) { 
            $self->_store_file_info('Header',$object,$found,$key, $check, $v_ref)
        }
        else {
            # try anyway to trigger an error message
            my $unexpected_obj = $root->fetch_element($key);
            $self->store_section_leaf_element ( $unexpected_obj, $check, $v_ref);
        }
    }
    
    $logger->info("Third pass to read Files sections from $args{file} control file");
    foreach my $file_name (@file_names) {
        $logger->debug("Creating Files:'$file_name' element");
        my $object =  $root->fetch_element('Files')->fetch_with_id(index => $file_name, check => $check) ;
   
        my $section = $file_paragraph{$file_name} ;
        for (my $i=0; $i < @$section ; $i += 2 ) {
            my $key = $section->[$i];
            my $v_ref = $section->[$i+1] ;

            next if $key =~ /^files$/i; # already done just before this loop

            # these represent information from the first line only
            my ($v1,$l1,$a1) = $v_ref->[0]->@*;

            $logger->info("reading key $key from file paragraph '$file_name' line $l1 for ".$object->name);
            $logger->debug("$key first line value: '$v1'");

            if ($key =~ /^licen[sc]e$/i) {
                my $lic_node = $object->fetch_element('License') ;
                $self->_store_license_info ($lic_node, $key, $check, $v_ref);
            }
            elsif (my $found = $object->find_element($key, case => 'any')) { 
                $self->_store_file_info('File',$object,$found,$key, $check, $v_ref);
            }
            else {
                # try anyway to trigger an error message
                my $unexpected_obj = $root->fetch_element($key);
                $self->store_section_leaf_element ( $unexpected_obj, $check, $v_ref);
            }
        }
    }

    return 1 ;
}

sub append_text_no_synopsis ($self, $logger_param, $object, $check, $v_ref) {
    my $old = $object->fetch(check => 'no');
    my @new_ref = $v_ref->@*;
    if ($old) {
        $user_logger->warn("double entry for ",$object->name,", appending value");
        unshift @new_ref, [ $old, 0, ''];
    }

    $self->store_section_leaf_element($logger_param,$object, $check, \@new_ref);
    return;
}

sub _store_line {
    my ($object,$v,$check) = @_ ;
    $v =~ s/^\s*\n// ; # remove leading blank line for uniline values
    chomp $v ;
    $logger->debug("_store_line with check $check ".$object->name." = $v");
    $object->store(value => $v, check => $check) ; 
    return;
}

sub _store_file_info ($self,$section, $object, $target_name,$key, $check, $v_ref) {
    my $target = $object->fetch_element($target_name) ;
    my $type = $target->get_type ;
    my $dispatcher = $type eq 'leaf' ? $target->value_type : $type ;
    my $f =  $store_dispatch{$dispatcher}
        || die "Error in $section section (line ".$v_ref->[0][1]."): unexpected '$key' field\n";
    $self->$f($logger, $target,$check,$v_ref) ;
    return;
}

sub _store_license_info ($self, $lic_node, $key, $check, $v_ref ) {
    if ( $key =~ /licence/ ) {
        $user_logger->warn( "Found UK spelling: $key will be converted to License" );
        $lic_node->notify_change(
            note   => 'change UK spelling to US spelling',
            really => 1
        );
    }
    $self->_store_file_license( $lic_node, $check, $v_ref );
    return;
}

sub _store_file_license ($self, $lic_object, $check, $v_ref) {

    return unless grep { /\S/ } map {$_->[0]} $v_ref->@*; # skip empty-ish value

    my ( $lic_line_ref, @lic_text_ref ) = $v_ref->@*;
    my $lic_line = $lic_line_ref->[0];
    $logger->debug("_store_file_license check $check called on ".$lic_object->name);

    $lic_line_ref->[0] =~ s/\s*\|\s*/ or /g; # old way of expressing or condition
    $lic_line_ref->[0] ||= 'other' ;
    $logger->debug("license short_name: ".$lic_line_ref->[0]);

    if (@lic_text_ref) {
        my $full_obj = $lic_object->fetch_element('full_license');
        $self->store_section_leaf_element ($logger, $full_obj, $check, \@lic_text_ref);
    }

    my $short_name_obj = $lic_object->fetch_element('short_name');
    $self->store_section_leaf_element ($logger, $short_name_obj, $check, [ $lic_line_ref ]);
    return;
}

sub write ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args is:
    # object     => $obj,         # Config::Model::Node object
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'

    my $node = $args{object};

    my $my_leaf_cb = sub {
        my ( $scanner, $data_ref, $node, $element_name, $key, $leaf_object ) =
          @_;
        my $v = $leaf_object->fetch;
        return unless length($v) ;
        $logger->debug("my_leaf_cb: on $element_name ". (defined $key ? " key $key ":'') . "value $v");
        my $prefix = defined $key ? "$key\n" : '' ;
        push @{$data_ref->{one}}, $element_name, $prefix.$v ;
    };

    my $my_string_cb = sub {
        my ( $scanner, $data_ref, $node, $element_name, $index, $leaf_object ) = @_;
        my $v = $leaf_object->fetch;
        return unless length($v) ;
        $logger->debug("my_string_cb: on $element_name value $v");
        push @{$data_ref->{one}}, $element_name, "\n$v";    # text without synopsis
    };

    my $my_list_element_cb = sub {
        my ( $scanner, $data_ref, $node, $element_name, @idx ) = @_;
        my @v = $node->fetch_element($element_name)->fetch_all_values;
        $logger->debug("my_list_element_cb: on $element_name value @v");
        push @{$data_ref->{one}}, $element_name, \@v if @v;
    };

    my $file_license_cb = sub {
        my ($scanner, $data_ref,$node,@element_list) = @_;

        # your custom code using $data_ref
        $logger->debug("file_license_cb called on ",$node->name);
        my $lic_text  = $node->fetch_element_value('short_name');
        my $full_lic_text = $node->fetch_element_value('full_license');
        $lic_text .= "\n" . $full_lic_text if defined $full_lic_text;
        push @{$data_ref->{one}}, License => $lic_text if defined $lic_text;
    };

    my $global_license_cb = sub {
        my ($scanner, $data_ref,$node,@element_list) = @_;

        # your custom code using $data_ref
        $logger->debug("file_license_cb called on ",$node->name);
        my $lic_text  = $node->fetch_element_value('short_name');
        my $full_lic_text = $node->fetch_element_value('full_license');
        $lic_text .= "\n" . $full_lic_text if defined $full_lic_text;
        push @{$data_ref->{one}}, License => $lic_text if defined $lic_text;
    };

    my $license_spec_cb = sub {
        my ($scanner, $data_ref,$node,@element_list) = @_;

        $logger->debug("license_spec_cb called on ",$node->name);
        my @section = ( 'License' , $node->index_value."\n") ;

        # resume exploration
        my $local_data_ref = { one => \@section, all => $data_ref->{all} } ;
        foreach my $elt (@element_list) { 
            if ($elt eq 'text') {
                $section[1] .= $node->fetch_element_value($elt) // '';
            }
            else {
                $scanner->scan_element($local_data_ref, $node,$elt);
            }
        }
        
        push @{$data_ref->{all}}, \@section;
    };

    my $file_cb = sub {
        my ($scanner, $data_ref,$node,@element_list) = @_;
        my @section = ( $node->element_name, $node->index_value );
        $logger->debug("file_cb called on ",$node->name);
        # resume exploration
        my $local_data_ref = { one => \@section, all => $data_ref->{all} } ;
        foreach (@element_list) { 
            $scanner->scan_element($local_data_ref, $node,$_);
        }
        push @{$data_ref->{all}}, \@section;
    };
    
    my $scan = Config::Model::ObjTreeScanner->new(
        leaf_cb         => $my_leaf_cb,
        #string_value_cb => $my_string_cb,
        list_element_cb => $my_list_element_cb,
        #hash_element_cb => $my_hash_element_cb,
        #node_element_cb => $my_node_element_cb,
        node_dispatch_cb => {
            'Dpkg::Copyright::FileLicense' => $file_license_cb ,
            'Dpkg::Copyright::GlobalLicense' => $global_license_cb ,
            'Dpkg::Copyright::LicenseSpec' => $license_spec_cb ,
            'Dpkg::Copyright::Content' => $file_cb,
        }
    );

    my @sections;
    my @section1 ;
    $scan->scan_node( { one => \@section1, all => \@sections } , $node );

    unshift @sections, \@section1 ;
    
    #use Data::Dumper ; print Dumper \@sections ; exit ;
    my $res = $self->write_dpkg_file( \@sections, "\n" );
    $args{file_path}->spew_utf8($res);

    return 1;
}


1;

__END__

=head1 NAME

Config::Model::Backend::Dpkg::Copyright - Read and write Debian Dpkg License information

=head1 SYNOPSIS

No synopsis. This class is dedicated to configuration class C<Dpkg::Copyright>

=head1 DESCRIPTION

This module is used directly by L<Config::Model> to read or write the
content of a configuration tree written with Debian C<Dep-5> syntax in
C<Config::Model> configuration tree. This syntax is used to specify 
license information in Debian source package format.

=head1 CONSTRUCTOR

=head2 new

Parameters: C<< node => $node_obj, name => 'Dpkg::Copyright' >>

Inherited from L<Config::Model::Backend::Any>. The constructor will be
called by L<Config::Model::AutoRead>.

=head2 read

Read data from copyright file and return 1.

=head2 write

Write data to copyright file and return 1.

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>, 
L<Config::Model::AutoRead>, 
L<Config::Model::Backend::Any>, 

=cut
