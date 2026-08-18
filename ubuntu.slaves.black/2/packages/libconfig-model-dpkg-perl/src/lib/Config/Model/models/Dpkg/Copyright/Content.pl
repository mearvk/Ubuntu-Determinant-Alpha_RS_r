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
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'element' => [
      'Copyright',
      {
        'description' => 'One or more free-form copyright statement(s), one per line, that apply to the files matched by the above pattern. If a work has no copyright holder (i.e., it is in the public domain), that information should be recorded here.

The Copyright field collects all relevant copyright notices for the files of this paragraph. Not all copyright notices may apply to every individual file, and years of publication for one copyright holder may be gathered together. For example, if file A has:

      Copyright 2008 John Smith Copyright 2009 Angela Watts

and file B has:

      Copyright 2010 Angela Watts

the Copyright field for a stanza covering both file A and file B need contain only:

      Copyright 2008 John Smith Copyright 2009, 2010 Angela Watts

The Copyright field may contain the original copyright statement copied exactly (including the word Copyright), or it can shorten the text, as long as it does not sacrifice information. Examples in this specification use both forms.',
        'mandatory' => '1',
        'type' => 'leaf',
        'value_type' => 'string',
        'warn_if_match' => {
          'UNKNOWN' => {
            'msg' => 'Unknown copyright owner: please add correct value or remove the File entry.'
          }
        }
      },
      'License',
      {
        'config_class_name' => 'Dpkg::Copyright::FileLicense',
        'type' => 'node'
      },
      'License-Alias',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'uniline'
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
      'X-Comment',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Copyright::Content'
  }
]
;

