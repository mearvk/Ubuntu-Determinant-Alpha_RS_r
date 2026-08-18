package Config::Model::Backend::DpkgSyntax ;

use strict;
use warnings;
use Mouse::Role;

use Carp;
use Config::Model::Exception ;
use Log::Log4perl qw(get_logger :levels);
use 5.20.0;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

my $logger = get_logger("Backend.Dpkg.Syntax") ;
my $user_logger = get_logger('User');

sub parse_dpkg_file {
    my $self = shift ;
    my $file_path = shift;
    my $check = shift || 'yes' ;
    my $comment_allowed = shift || 0 ;

    return  unless $file_path->is_file ;

    my @lines = $file_path->lines_utf8 ;
    chomp @lines ;

    return $self->parse_dpkg_lines ($file_path, \@lines, $check, $comment_allowed);
}

#
# New subroutine "parse_dpkg_lines" extracted - Tue Jul 19 17:47:58 2011.
#
sub parse_dpkg_lines {
    my ($self, $file_path, $lines, $check, $comment_allowed, $handle_garbage) = @_ ;

    my $field;
    my $store_list_ref ;       # hold field data
    my @comments;         # hold comment data
    my $store_list = [] ; # holds sections

    my $key = '';
    my $line_nb = 1 ;
    my $section_line = 1 ;
    
    # list of list ( $line_nb_nb, section, ... ) where section is
    # [keyword,[ maybe keyword comments, .. , [ value, line_nb, altered , comment ] , ... ])
    my @res ;

    foreach my $l (@$lines) {
        $logger->trace("Parsing $file_path line $line_nb '$l'");
        if ( $l =~ /^#/) { # comment are always located before the keyword (hopefully)
            if ($comment_allowed) {
                my $c = $l ;
                $c =~ s/#// ;
                $logger->trace("line $line_nb is comment '$l'");
                push @comments, $c ;
            }
            else {
                Config::Model::Exception::Syntax->throw (
                    object => $self,
                    parsed_file => $file_path,
                    parsed_line => $line_nb,
                    message => "Comments are not allowed. (use -force option to drop comments)",
                ) if $check eq 'yes' ;
                $user_logger->warn("File $file_path: Dropped comment line $line_nb");
            }
        }
        elsif ( $l =~ m{^([\w\-]+)\s*:(?!//)} ) {  # keyword: but not http://
            my ($field,$text) = split /\s*:\s*/,$l,2 ;
            $text =~ s/\s+$//;
            $key = $field ;
            $logger->trace("$file_path line $line_nb start new field $key with '$text'");

            # @$store_list will be used in a hash, where the $field is key
            # store value found, file line number, is value altered (used later, not for now)
            # and comments
            $store_list_ref = [ @comments,  [ $text , $line_nb, '' ] ];
            @comments = () ;
            push @$store_list, $field, $store_list_ref ;
        }
        elsif ( $key and $l =~ /^\s*$/ ) {     # first empty line after a section
            $logger->trace("$file_path empty line $line_nb: starting new section");
            $key = '';
            push @res, $section_line, $store_list if @$store_list ; # don't store empty sections 
            $store_list = [] ;
            $section_line = $line_nb + 1; # next line, will be clobbered if next line is empty
            undef $store_list_ref ; # to ensure that next line contains a keyword
        }
        elsif ( $l =~ /^\s*$/ ) {     # "extra" empty line
            $handle_garbage->($l, $line_nb) if $handle_garbage ;
            $logger->trace("extra empty line: skipped");
            # just skip it
        } 
        elsif ( $l =~ /^\s+\.$/) {   # line with a single dot
            $logger->trace("dot line: adding blank line to field $key");
            _store_line_and_comments($store_list_ref,$file_path,".",$check,$line_nb, $handle_garbage, \@comments) ;
        }
        elsif ( $l =~ /^\s/) {     # non empty line
            $logger->trace("text line: adding '$l' to field $key");
            _store_line_and_comments($store_list_ref,$file_path,$l , $check,$line_nb, $handle_garbage, \@comments);
        }
        elsif ($handle_garbage) {
            $logger->trace("storing garbage in line $line_nb: $l");
            $handle_garbage->($l, $line_nb, \@comments) ;
        }
        else {
            my $msg = "DpkgSyntax error: Invalid line (missing ':' ?) : $l" ;
            Config::Model::Exception::Syntax -> throw (
                message => $msg,
                parsed_file => $file_path,
                parsed_line => $line_nb
            ) if $check eq 'yes' ;
            $logger->error($msg) if $check eq 'skip';
        }
        $line_nb++;
    }

    # store last section if not empty
    push @res, $section_line, $store_list if @$store_list;


    if ($logger->is_debug ) {
        for (my $i = 0 ; 2*$i < $#res ; $i++  ) {
            my $l = $res[$i*2];
            my $s = $res[$i*2 + 1];
            my %section_data = @$s;

            $logger->debug("Parse result section $i, found:") ;
            foreach my $key (keys %section_data) {
                my $data = $section_data{$key};
                # first entry may be a comment
                my $kd;
                foreach my $it (@$data) {
                    if (ref $it) {
                        $kd =  $it->[0];
                        last;
                    }
                }
                $logger->debug( "$key: $kd" . (@$data > 1 ? ' ...':'')) ;
            }
        }
    }

    $logger->warn("No section found in file $file_path") unless @res ;

    return wantarray ? @res : \@res ;
}

sub _store_line_and_comments ($store_ref,$file_path,$line,$check,$line_nb, $handle_garbage, $comments) {

    if (defined $store_ref) {
        substr $line,0,1,''; # remove first char which shows field continuation
        push $store_ref->@* , [ $line , $line_nb, '', $comments->@* ]
    }
    elsif ($handle_garbage) {
        $logger->trace("storing garbage in line $line_nb: $line");
        $handle_garbage->($line, $line_nb, $comments->@*) ;
    }
    else {
        my $msg = "Did not find a keyword before: '$line''";
        Config::Model::Exception::Syntax -> throw (
            message => $msg,
            parsed_file => $file_path,
            parsed_line => $line_nb
        ) if $check eq 'yes' ; 
        $logger->error($msg) if $check eq 'skip';
    }
    $comments->@* = (); # reset comments, they are now stored
    return;
}

# input is [ section [ keyword => value | value_list_ref ] ]
sub write_dpkg_file {
    my ($self, $array_ref,$list_sep) = @_ ;

    my @lines = $self->format_dpkg_section(shift @$array_ref,$list_sep) ;

    foreach my $section (@$array_ref) {
        push @lines, '', $self->format_dpkg_section($section,$list_sep) ;
    }
    return join("\n", @lines ). "\n";
}

# TODO: also rework coyright and dpkgpatch to cope with new data structure

# input is [ may_be_comment, keyword => value | value_list_ref, ... ]
sub format_dpkg_section ($self, $array_ref, $list_sep) {
    $array_ref //= [] ;
    my @lines ;

    my $i = 0;
    foreach (my $i=0; $i < @$array_ref; $i += 2 ) {
        while ($array_ref->[$i] =~ /^#/) {
            # print comment
            push @lines, $array_ref->[$i++] ;
        }
        my $name  = $array_ref->[$i] ;
        my $value = $array_ref->[$i + 1];

        if (ref ($value)) {
            push @lines, $self->format_dpkg_list($name, $value, $list_sep) ;
        }
        else {
            push @lines, $self->format_dpkg_text($name, $value) ;
        }
    }

    return @lines;
}

# since list_sep may contain a \n or not, the list is formatted as a string
sub format_dpkg_list ($self, $name, $value_list_ref, $list_sep) {
    my $result = '';

    my $sep = $list_sep // ",\n" ;
    my $pad = $sep =~ /\n$/ ? ' ' x (length ($name) + 2) : '' ;

    my $idx = 0;
    foreach my $item ($value_list_ref->@*) {
        my ($list_elt, $comment_elt) =  ref($item) ? $item->@* : ($item);
        if ($comment_elt and $sep !~ /\n/) {
            $logger->error("Cannot store comment when list is stored on a single line\nDropping '$comment_elt'");
            $comment_elt = '';
        }
        if ($idx == 0 and $comment_elt) {
            $result .= $self->format_label_line($name, '')."\n";
            $result .= $comment_elt . "\n" . $pad . $list_elt  ;
        }
        elsif ($idx == 0) {
            $result .= $self->format_label_line($name, $list_elt) ;
        }
        else {
            $result .= $comment_elt."\n" if $comment_elt;
            $result .= $pad.$list_elt;
        }
        $result .= $sep unless $idx == $value_list_ref->$#*;
        $idx++ ;
    }
    return $result;
}

sub write_dpkg_text {
    my ($self, $text) = @_ ;
    return  join("\n", $self->format_dpkg_text('',$text)). "\n" ;
}

sub format_dpkg_text {
    my ($self, $name, $text) = @_ ;

    return unless $text ;
    my @lines = split /\n/,$text ;
    my $label_line = $self->format_label_line($name, shift @lines);

    foreach (@lines) {
        s/^/ /gm; # insert leading white space
        s/^\s*$/ ./gm ; # insert dot for empty lines
    }
    return ($label_line, @lines) ;
}

sub format_label_line {
    my ($self, $name, $v0) = @_ ;
    return $v0 unless $name;
    my $label_line = $name.":";
    $label_line .= ' '.$v0 if $v0 =~ /\S/;
    return $label_line;
}

sub node_to_section ($self, $node, $elt_list = [ $node->get_element_names ]) {

    my @section ;
    my $description_ref ;
    foreach my $elt ( $elt_list->@* ) {
        my $type = $node->element_type($elt) ;
        my $elt_obj = $node->fetch_element($elt) ;

        my $c = $elt_obj->annotation ;
        push @section, map {'#'.$_} split /\n/,$c if $c ;

        if ($type eq 'hash') {
            die "package_spec: unexpected hash type in ".$node->name." element $elt\n" ;
        }
        elsif ($type eq 'list') {
            my @v;
            my @indexes = $elt_obj->fetch_all_indexes;

            foreach my $idx (@indexes) {
                my $value_obj = $elt_obj->fetch_with_id($idx);
                my $value = $value_obj->fetch;
                next unless defined $value;

                my $note = $value_obj->annotation;
                my $comment = $note ? join ("\n",map {'#'.$_} split /\n/,$note ) : undef;
                push @v, $comment ? [ $value, $comment ] : $value;
            }
            push @section, $elt , \@v if @v;
        }
        elsif ($type eq 'check_list') {
            my $v = $node->fetch_element($elt)->fetch ;
            push @section, $elt , $v if $v ;
        }
        elsif ($elt eq 'Synopsis') {
            my $v = $node->fetch_element_value($elt) ;
            push @section, 'Description' , $v ; # mandatory field
            $description_ref = \$section[$#section] ;
        }
        elsif ($elt eq 'Description') {
            # annotation attached to Description is written as a
            # comment *after* the Description block
            $$description_ref .= "\n".$node->fetch_element_value($elt) ; # mandatory field
        }
        else {
            my $v = $node->fetch_element_value($elt) ;
            push @section, $elt , $v if $v ;
        }
    }
    return @section ;
}
1;

__END__

=head1 NAME

Config::Model::Backend::DpkgSyntax - Role to read and write files with Dpkg syntax

=head1 SYNOPSIS

With a dpkg file containing:

 Name: Foo
 Version: 1.2

 # section comment
 Name: Bar
 # data comment
 Version: 1.3
 Files: file1,
 # inline comment
        file2
 Description: A very
  .
  long description

Parse the file with:

 package MyParser ;

 use strict;
 use warnings;

 use 5.20.1;

 # DpkgSyntax uses Log4perl, so we must initialise this module
 use Log::Log4perl qw(:easy);
 Log::Log4perl->easy_init($WARN);

 # load role
 use Mouse ;
 with 'Config::Model::Backend::DpkgSyntax';

 package main ;
 use Path::Tiny;
 use YAML::XS;

 # load control file
 my $file = path('dpkg-test');

 # create your parser
 my $parser = MyParser->new() ;

 # convert control file data in a Perl data structure
 # documented in Synopsis
 my $data = $parser->parse_dpkg_file($file, 'yes', 1);

Data contains:

 [
   1,          # section 1 found in line 1
   [
     'Name',    # first parameter
       [
         'section comment',
         [
           'Foo',  # first parameter data
           1,      # also found in line 1
           ''      # currently always empty
         ]
       ],
    'Version', [ 'data comment', ['1.2', 2, '']]
   ],          # end of section 1
   4,          # section 2 found in line 4
   [
     'Name', [['Bar', 5, '']],
     'Version', [['1.3', 7, '']],
     'Files', # param with 2 lines
     [
       ['file1,', 8, ''],
       ['      file2', 10, '', 'inline comment'] # padding is kept
     ],
     'Description', # param with 3 lines
     [
       ['A very', 11, ''],
       ['', 12, ''],  # empty line, note: dot was removed
       ['long description', 13, '']
     ]
   ]                  # end of section 2
 ];                   # end of data

To write Dpkg file back:

 package MyParser ;

 use strict;
 use warnings;

 use 5.20.1;

 # DpkgSyntax uses Log4perl, so we must initialise this module
 use Log::Log4perl qw(:easy);
 Log::Log4perl->easy_init($WARN);

 # load role
 use Mouse ;
 with 'Config::Model::Backend::DpkgSyntax';

 package main ;
 use Path::Tiny;

 my $data = [
     [
         '# section comment', qw/Name Foo/,
         '# data comment', qw/Version 1.2/
     ],
     [
         qw/Name Bar Version 1.3/ ,
         Files => [qw/file1/, [ 'file2' , '# inline comment'] ] ,
         Description => "A very\n\nlong description"
     ]
 ];

 my $parser = MyParser->new() ;

 # print control file content
 say $parser->write_dpkg_file($data) ;


=head1 DESCRIPTION

This module is a Moose role to read and write dpkg control files.

Debian control file are read and transformed in a structure
matching the control file. The top level list of a list of section.

Each section is mapped to a structure containing the parameter names and values, 
comments and line numbers. See the synopsis for an example.

Note: The description is changed into a paragraph without the Dpkg
syntax idiosyncrasies. The leading white space is removed and the
single dot is transformed in to a "\n". These characters are restored
when the file is written back.

Last not but not least, this module can be re-used outside of
C<Config::Model> with some small modifications in exception
handling. Ask the author if you want this module shipped in its own
distribution.

=head1

=head2 parse_dpkg_file

Parameters: C<( file_path, file_handle, [ check, [ comment_allowed ]] )>

Read a control file from C<file_handle> and returns a nested list (or
a list ref) containing data from the file.

See synopsis for the returned structure.

C<check> is C<yes>, C<skip> or C<no> (default C<yes>).
 C<comment_allowed> is boolean (default 0)

=head2 parse_dpkg_lines

Parameters: C< ( file_path, lines, check, comment_allowed ) >

Parse the dpkg date from lines (which is an array ref) and return a data 
structure like L<parse_dpkg_file>.

=head2 write_dpkg_file

Parameters C< ( list_ref, list_sep ) >

Munge the passed list ref into a string compatible with control files
and write it in the passed file handle.

The input is a list of list in a form similar to the one generated by
L<parse_dpkg_file>. See the synopsis for an example

List items (like C<Depends> field in C<debian/control>) are joined
with the value C<list_sep> before being written. Values are aligned in
case of multi-line output of a list. Default value of C<list_sep> is "C<,\n>"

For instance, after the following code :

 my $ref = [ [ Foo => 'foo value' , Bar => [ 'v1', 'v2' ] ];
 my $res = write_dpkg_file ( $ref, ', ' )

C<$res> contains:

 Foo: foo value
 Bar: v1, v2

Here's an example using default C<$sep_list>:

 print write_dpkg_file ( $ref )

yields:

 Foo: foo value
 Bar: v1,
      v2

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>,
L<Config::Model::BackendMgr>,
L<Config::Model::Backend::Any>,

=cut
