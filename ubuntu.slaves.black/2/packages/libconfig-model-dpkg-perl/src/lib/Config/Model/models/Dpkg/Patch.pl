use strict;
use warnings;

return [
  {
    'accept' => [
      'Bug-.*',
      {
        'accept_after' => 'Bug',
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'type' => 'list'
      }
    ],
    'element' => [
      'Synopsis',
      {
        'description' => 'This line is stored in the first line of DEP-3 description
field',
        'summary' => 'short description of the patch',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if_match' => {
          '.{80,}' => {
            'msg' => 'Synopsis is too long. '
          }
        },
        'warn_unless' => {
          'empty' => {
            'code' => '(defined $_ && /\\w/ ) or ($self->grab_value(\'- Subject\') =~ /\\w/) ;',
            'fix' => 'my $node = $self->parent;
$_ = ucfirst( $node->index_value // $node->instance->backend_arg // \'please fill synopsis\' )  ;
s/-/ /g;
s/\\.patch$//;
s/^\\d+\\s*//;
',
            'msg' => 'Empty synopsis'
          }
        }
      },
      'Description',
      {
        'description' => 'verbose explanation of the patch and its history.',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'Subject',
      {
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Bug',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'This field contains one URL pointing to the related bug (possibly fixed by the patch). The Bug field is reserved for the bug URL in the upstream bug tracker. Those fields can be used multiple times if several bugs are concerned.

The vendor name is explicitly encoded in the field name so that vendors can share patches among them without having to update the meta-information in most cases. The upstream bug URL is special cased because it\'s the central point of cooperation and it must be easily distinguishable among all the bug URLs.

To get a vendor bug (like Bug-Foo) in the graphical editor, right-click on the patch name, enter "C<Bug-Foo>" (or any other value) in the "C<accept:>" entry and hit "Return". A new element will be created that
you can fill like the C<Bug> field.',
        'summary' => 'URL for related upstream bug(s)',
        'type' => 'list'
      },
      'Bug-Debian',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline',
          'warn_if_match' => {
            '^#?\\d+$' => {
              'fix' => 's!^!https://bugs.debian.org/!;',
              'msg' => 'This field should contain an URL to Debian BTS and not just a bug number'
            },
            '^\\s' => {
              'fix' => 's/^\\s+//;',
              'msg' => 'Leading white space (cut\'n\'paste error ?)'
            },
            'https://bugs.debian.org/cgi-bin/bugreport\\.cgi\\?bug=' => {
              'fix' => 's!/cgi-bin/bugreport\\.cgi\\?bug=!/!',
              'msg' => 'You should use the simplified form of BTS URL'
            }
          },
          'warn_unless_match' => {
            '^https' => {
              'fix' => 's!^http://!https://!',
              'msg' => 'https protocol should be used instead of http'
            },
            '^https?://bugs\\.debian\\.org/' => {
              'fix' => 's!https?://[^/]*!https://bugs.debian.org!',
              'msg' => 'Unknown host or protocol for Debian BTS'
            }
          }
        },
        'description' => 'This field contains one URL pointing to the related bug (possibly fixed by the patch). The Bug-Debian field is reserved for the bug URL in Debian BTS. Those fields can be used multiple times if several bugs are concerned.',
        'summary' => 'URL for related bug in Debian BTS',
        'type' => 'list'
      },
      'Forwarded',
      {
        'description' => 'Any value other than "no" or "not-needed" means that the patch has been forwarded upstream. Ideally the value is an URL proving that it has been forwarded and where one can find more information about its inclusion status.

If the field is missing, its implicit value is "yes" if the "Bug" field is present, otherwise it\'s "no". The field is really required only if the patch is vendor specific, in that case its value should be "not-needed" to indicate that the patch must not be forwarded upstream (whereas "no" simply means that it has not yet been done).

',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Author',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'This field can be used to record the name and email of the patch author (ex: "John Bear <foo@example.com>"). Its usage is recommended when the patch author did not add copyright notices for his work in the patch itself. It\'s also a good idea to add this contact information when the patch needs to be maintained over time because it has very little chance of being integrated upstream. This field can be used multiple times if several people authored the patch.',
        'type' => 'list'
      },
      'Origin',
      {
        'description' => 'This field should document the origin of the patch. In most cases, it should be a simple URL. For patches backported/taken from upstream, it should point into the upstream VCS web interface when possible, otherwise it can simply list the relevant commit identifier (it should be prefixed with "commit:" in that case). For other cases, one should simply indicate the URL where the patch was taken from (mailing list archives, distribution bugtrackers, etc.) when possible.

The field can be optionally prefixed with a single keyword followed by a comma and a space to categorize the origin. The allowed keywords are "upstream" (in the case of a patch cherry-picked from the upstream VCS), "backport" (in the case of an upstream patch that had to be modified to apply on the current version), "vendor" for a patch created by Debian or another distribution vendor, or "other" for all other kind of patches.

In general, a user-created patch grabbed in a BTS should be categorized as "other". When copying a patch from another vendor, the meta-information (and hence this field) should be kept if present, or created if necessary with a "vendor" origin.

If the Author field is present, the Origin field can be omitted and it\'s assumed that the patch comes from its author.',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'From',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Like Author field, this field can be used to record the name and email of the patch author (ex: "John Bear <foo@example.com>"). Its usage is recommended when the patch author did not add copyright notices for his work in the patch itself. It\'s also a good idea to add this contact information when the patch needs to be maintained over time because it has very little chance of being integrated upstream. This field can be used multiple times if several people authored the patch.',
        'type' => 'list'
      },
      'Reviewed-by',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'This field can be used to document the fact that the patch has been reviewed and approved by someone. It should list her name and email in the standard format (similar to the example given for the Author field). This field can be used multiple times if several people reviewed the patch.

',
        'type' => 'list'
      },
      'Acked-by',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Synonym to Reviewd-by. This field can be used to document the fact that the patch has been reviewed and approved by someone. It should list her name and email in the standard format (similar to the example given for the Author field). This field can be used multiple times if several people reviewed the patch.

',
        'type' => 'list'
      },
      'Last-Update',
      {
        'description' => 'This field can be used to record the date when the meta-information was last updated. It should use the ISO date format YYYY-MM-DD.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Applied-Upstream',
      {
        'description' => 'This field can be used to document the fact that the patch has been applied upstream. It may contain the upstream version expected to contain this patch, or the URL or commit identifier of the upstream commit (with commit identifiers prefixed with "commit:", as in the Origin field), or both separated by a comma and a space.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'diff',
      {
        'description' => 'This element contains the diff that will be used to patch the source. Do not modify unless you really know
what you\'re doing.',
        'summary' => 'actual patch',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'name' => 'Dpkg::Patch',
    'rw_config' => {
      'backend' => 'Dpkg::Patch',
      'config_dir' => 'debian/patches'
    }
  }
]
;

