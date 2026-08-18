use strict;
use warnings;

return [
  {
    'accept' => [
      '.*',
      {
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'author' => [
      'Dominique Dumont'
    ],
    'class' => 'Config::Model::Dpkg::Copyright',
    'class_description' => 'Machine-readable debian/copyright. Parameters from former version 
of DEP-5 are flagged as deprecated. The idea is to enable migration from older 
specs to CANDIDATE spec.

To edit a copyright file, go into your package development directory and run:

  cme edit dpkg-copyright
   
To check you file run:

  cme check dpkg-copyright
    
To upgrade your file from an old spec, run:

  cme migrate dpkg-copyright
',
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'element' => [
      'Format',
      {
        'default' => 'https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/',
        'description' => 'URI of the format specification.',
        'mandatory' => '1',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_unless_match' => {
          '^https' => {
            'fix' => '$_ = undef;',
            'msg' => 'Format uses insecure http protocol instead of https'
          },
          '^https?://www.debian.org/doc/packaging-manuals/copyright-format/1\\.0/?$' => {
            'fix' => '$_ = undef;',
            'msg' => 'Format does not match the recommended URL for DEP-5'
          }
        }
      },
      'Upstream-Name',
      {
        'description' => 'The name upstream uses for the software.',
        'migrate_from' => {
          'formula' => '$name',
          'variables' => {
            'name' => '- Name'
          }
        },
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Upstream-Contact',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'The preferred address(es) to reach the upstream project. May be free-form text, but by convention will usually be written as a list of RFC5822 addresses or URIs.',
        'migrate_values_from' => '- Upstream-Maintainer',
        'type' => 'list'
      },
      'Source',
      {
        'description' => 'An explanation from where the upstream source came from. Typically this would be a URL, but it might be a free-form explanation. The Debian Policy, 12.5 requires this information unless there are no upstream sources, which is mainly the case for native Debian packages. If the upstream source has been modified to remove non-free parts, that should be explained in this field.',
        'migrate_from' => {
          'formula' => '$old || $older ;',
          'undef_is' => '\'\'',
          'use_eval' => '1',
          'variables' => {
            'old' => '- Upstream-Source',
            'older' => '- Original-Source-Location'
          }
        },
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'Disclaimer',
      {
        'description' => 'This field can be used in the case of non-free and contrib packages (see [Policy 12.5]( http://www.debian.org/doc/debian-policy/ch-docs.html#s-copyrightfile))',
        'type' => 'leaf',
        'value_type' => 'string',
        'warn_if_match' => {
          'dh-make-perl' => {
            'fix' => '$_ = undef ;',
            'msg' => 'Disclaimer contains dh-make-perl boilerplate'
          }
        }
      },
      'Comment',
      {
        'description' => 'This field can provide additional information. For example, it might quote an e-mail from upstream justifying why the license is acceptable to the main archive, or an explanation of how this version of the package has been forked from a version known to be DFSG-free, even though the current upstream version is not.',
        'migrate_from' => {
          'formula' => '$old',
          'variables' => {
            'old' => '- X-Comment'
          }
        },
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'Copyright',
      {
        'description' => 'Copyright information for the package as a whole, which may be different or simplified from a combination of all the per-file copyright information. See also Copyright below in the Files paragraph section.',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'Files',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::Copyright::Content',
          'type' => 'node'
        },
        'description' => 'Patterns indicating files having the same license and sharing copyright holders.
See L<files pattern documentation|https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/#files-field> for details.',
        'index_type' => 'string',
        'ordered' => '1',
        'type' => 'hash',
        'warn_if_key_match' => '[\\[\\]\\|]'
      },
      'Files-Excluded',
      {
        'description' => 'White space separated list of file patterns to exclude from the package. This field is only used by L<uscan>. Example: C<*/Makefile.in aclocal.m4>. See also L<UscanEnhancements|https://wiki.debian.org/UscanEnhancements> and the L<files pattern documentation|https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/#files-field>.',
        'type' => 'leaf',
        'value_type' => 'string',
        'warn_if_match' => {
          '\\/(\\s|$)' => {
            'fix' => 's!/(?=\\s|$)!!g;',
            'msg' => 'directory entries should not have a trailing slash'
          }
        }
      },
      'Global-License',
      {
        'config_class_name' => 'Dpkg::Copyright::GlobalLicense',
        'type' => 'node'
      },
      'Format-Specification',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Name',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Maintainer',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Line(s) containing the preferred address(es) to reach current upstream maintainer(s). May be free-form text, but by convention will usually be written as a list of RFC2822 addresses or URIs.',
        'status' => 'deprecated',
        'type' => 'list'
      },
      'Upstream-Maintainer',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'migrate_values_from' => '- Maintainer',
        'status' => 'deprecated',
        'type' => 'list'
      },
      'Upstream-Source',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'Original-Source-Location',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'License',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::Copyright::LicenseSpec',
          'type' => 'node'
        },
        'class' => 'Config::Model::Dpkg::Copyright::License',
        'index_type' => 'string',
        'type' => 'hash'
      },
      'X-Comment',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Copyright',
    'rw_config' => {
      'auto_create' => '1',
      'backend' => 'Dpkg::Copyright',
      'config_dir' => 'debian',
      'file' => 'copyright'
    }
  }
]
;

