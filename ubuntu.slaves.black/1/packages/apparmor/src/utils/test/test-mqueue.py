#!/usr/bin/python3
# ----------------------------------------------------------------------
#    Copyright (C) 2022 Canonical, Ltd.
#
#    This program is free software; you can redistribute it and/or
#    modify it under the terms of version 2 of the GNU General Public
#    License as published by the Free Software Foundation.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
# ----------------------------------------------------------------------

import unittest
from collections import namedtuple
from common_test import AATest, setup_all_loops

from apparmor.rule.mqueue import MessageQueueRule, MessageQueueRuleset
from apparmor.common import AppArmorException, AppArmorBug
from apparmor.translations import init_translation
_ = init_translation()


class MessageQueueTestParse(AATest):
    tests = (
        #                                                           access type label mqueue_name audit deny allow comment
        ('mqueue,'                               , MessageQueueRule(MessageQueueRule.ALL, MessageQueueRule.ALL, MessageQueueRule.ALL, MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue create,'                        , MessageQueueRule(('create'), MessageQueueRule.ALL, MessageQueueRule.ALL, MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue (create,open,delete),'          , MessageQueueRule(('create', 'open', 'delete'), MessageQueueRule.ALL, MessageQueueRule.ALL, MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue (getattr,setattr),'             , MessageQueueRule(('getattr', 'setattr'), MessageQueueRule.ALL, MessageQueueRule.ALL, MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue (write,read),'                  , MessageQueueRule(('write', 'read'), MessageQueueRule.ALL, MessageQueueRule.ALL, MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue (open,delete),'                 , MessageQueueRule(('open', 'delete'), MessageQueueRule.ALL, MessageQueueRule.ALL, MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue write label=foo,'               , MessageQueueRule(('write'), MessageQueueRule.ALL, 'foo', MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue read label=foo /queue,'         , MessageQueueRule(('read'), MessageQueueRule.ALL, 'foo', '/queue', False, False, False, '')),
        ('audit mqueue read label=foo /queue,'   , MessageQueueRule(('read'), MessageQueueRule.ALL, 'foo', '/queue', True, False, False, '')),
        ('deny mqueue rw label=foo /queue,'      , MessageQueueRule(('rw'), MessageQueueRule.ALL, 'foo', '/queue', False, True, False, '')),
        ('audit allow mqueue r label=foo /queue,', MessageQueueRule(('r'), MessageQueueRule.ALL, 'foo', '/queue', True, False, True, '')),
        ('mqueue w label=foo 1234, # cmt'        , MessageQueueRule(('w'), MessageQueueRule.ALL, 'foo', '1234', False, False, False, ' # cmt')),
        ('mqueue wr 1234,'                       , MessageQueueRule(('wr'), MessageQueueRule.ALL, MessageQueueRule.ALL, '1234', False, False, False, '')),
        ('mqueue 1234,'                          , MessageQueueRule(MessageQueueRule.ALL, MessageQueueRule.ALL, MessageQueueRule.ALL, '1234', False, False, False, '')),
        ('mqueue type=sysv,'                     , MessageQueueRule(MessageQueueRule.ALL, 'sysv', MessageQueueRule.ALL, MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue type=posix,'                    , MessageQueueRule(MessageQueueRule.ALL, 'posix', MessageQueueRule.ALL, MessageQueueRule.ALL, False, False, False, '')),
        ('mqueue type=sysv 1234,'                , MessageQueueRule(MessageQueueRule.ALL, 'sysv', MessageQueueRule.ALL, '1234', False, False, False, '')),
        ('mqueue type=posix /queue,'             , MessageQueueRule(MessageQueueRule.ALL, 'posix', MessageQueueRule.ALL, '/queue', False, False, False, '')),
        ('mqueue open type=sysv label=foo 1234,' , MessageQueueRule(('open'), 'sysv', 'foo', '1234', False, False, False, '')),
    )

    def _run_test(self, rawrule, expected):
        self.assertTrue(MessageQueueRule.match(rawrule))
        obj = MessageQueueRule.parse(rawrule)
        expected.raw_rule = rawrule.strip()
        self.assertTrue(obj.is_equal(expected, True))


class MessageQueueTestParseInvalid(AATest):
    tests = (
        ('mqueue label=,'                  , AppArmorException),
        ('mqueue invalidaccess /queuename,', AppArmorException),
        ('mqueue invalidqueuename,'        , AppArmorException),
        ('mqueue invalidqueuename1234,'    , AppArmorException),
        ('mqueue foo label foo bar,'       , AppArmorException),
        ('mqueue type=,'                   , AppArmorException),
        ('mqueue type=sysv /foo,'          , AppArmorException),
        ('mqueue type=posix 1234,'         , AppArmorException),
    )

    def _run_test(self, rawrule, expected):
        self.assertTrue(MessageQueueRule.match(rawrule))  # the above invalid rules still match the main regex!
        with self.assertRaises(expected):
            MessageQueueRule.parse(rawrule)

    def test_parse_fail(self):
        with self.assertRaises(AppArmorException):
            MessageQueueRule.parse('foo,')

    def test_diff_non_mqueuerule(self):
        exp = namedtuple('exp', ('audit', 'deny'))
        obj = MessageQueueRule(('open'), 'posix', 'bar', '/foo')
        with self.assertRaises(AppArmorBug):
            obj.is_equal(exp(False, False), False)

    def test_diff_access(self):
        obj1 = MessageQueueRule(('open'), 'posix', 'bar', '/foo')
        obj2 = MessageQueueRule(('create'), 'posix', 'bar', '/foo')
        self.assertFalse(obj1.is_equal(obj2, False))

    def test_diff_type(self):
        obj1 = MessageQueueRule(('open'), 'sysv', 'bar', MessageQueueRule.ALL)
        obj2 = MessageQueueRule(('open'), 'posix', 'inv', MessageQueueRule.ALL)
        self.assertFalse(obj1.is_equal(obj2, False))

    def test_diff_label(self):
        obj1 = MessageQueueRule(('open'), 'posix', 'bar', '/foo')
        obj2 = MessageQueueRule(('open'), 'posix', 'inv', '/foo')
        self.assertFalse(obj1.is_equal(obj2, False))

    def test_diff_mqueue_name(self):
        obj1 = MessageQueueRule(('open'), MessageQueueRule.ALL, 'bar', '/foo')
        obj2 = MessageQueueRule(('open'), MessageQueueRule.ALL, 'bar', '123')
        self.assertFalse(obj1.is_equal(obj2, False))


class InvalidMessageQueueInit(AATest):
    tests = (
        # init params                               expected exception
        (('write', 'sysv', '', '/foo'), AppArmorBug),  # empty label
        (('write', '', 'bar', '/foo'), AppArmorBug),  # empty type
        (('', 'sysv', 'bar', '/foo'), AppArmorBug),  # empty access
        (('write', 'sysv', 'bar', ''), AppArmorBug),  # empty mqueue_name
        (('    ', 'sysv', 'bar', '/foo'), AppArmorBug),  # whitespace access
        (('write', '    ', 'bar', '/foo'), AppArmorBug),  # whitespace type
        (('write', 'sysv', '   ', '/foo'), AppArmorBug),  # whitespace label
        (('write', 'sysv', 'bar', '    '), AppArmorBug),  # whitespace mqueue_name
        (('xyxy', 'sysv', 'bar', '/foo'), AppArmorException),  # invalid access
        ((dict(), '', 'bar', '/foo'), AppArmorBug),  # wrong type for access
        ((None, '', 'bar', '/foo'), AppArmorBug),  # wrong type for access
        (('write', dict(), 'bar', '/foo'), AppArmorBug),  # wrong type for type
        (('write', None, 'bar', '/foo'), AppArmorBug),  # wrong type for type
        (('write', '', dict(), '/foo'), AppArmorBug),  # wrong type for label
        (('write', '', None, '/foo'), AppArmorBug),  # wrong type for label
        (('write', '', 'bar', dict()), AppArmorBug),  # wrong type for mqueue_name
        (('write', '', 'bar', None), AppArmorBug),  # wrong type for mqueue_name
    )

    def _run_test(self, params, expected):
        with self.assertRaises(expected):
            MessageQueueRule(*params)

    def test_missing_params_1(self):
        with self.assertRaises(TypeError):
            MessageQueueRule()

    def test_missing_params_2(self):
        with self.assertRaises(TypeError):
            MessageQueueRule('r')

    def test_missing_params_3(self):
        with self.assertRaises(TypeError):
            MessageQueueRule('r', 'sysv')

    def test_missing_params_4(self):
        with self.assertRaises(TypeError):
            MessageQueueRule('r', 'sysv', 'foo')


class WriteMessageQueueTestAATest(AATest):
    tests = (
        #  raw rule                                               clean rule
        ('     mqueue         ,    # foo        '               , 'mqueue, # foo'),
        ('    audit     mqueue create,'                         , 'audit mqueue create,'),
        ('    audit     mqueue (open  ),'                       , 'audit mqueue open,'),
        ('    audit     mqueue (delete , read ),'               , 'audit mqueue (delete read),'),
        ('   deny mqueue         write      label=bar,# foo bar', 'deny mqueue write label=bar, # foo bar'),
        ('   deny mqueue         open      ,# foo bar'          , 'deny mqueue open, # foo bar'),
        ('   allow mqueue             label=tst    ,# foo bar'  , 'allow mqueue label=tst, # foo bar'),
        ('mqueue,'                                              , 'mqueue,'),
        ('mqueue (read),'                                       , 'mqueue read,'),
        ('mqueue (create),'                                     , 'mqueue create,'),
        ('mqueue (write read),'                                 , 'mqueue (read write),'),
        ('mqueue (open,create,open,delete,write,read),'         , 'mqueue (create delete open read write),'),
        ('mqueue r,'                                            , 'mqueue r,'),
        ('mqueue w,'                                            , 'mqueue w,'),
        ('mqueue rw,'                                           , 'mqueue rw,'),
        ('mqueue delete label="tst",'                           , 'mqueue delete label="tst",'),
        ('mqueue (getattr) label=bar,'                          , 'mqueue getattr label=bar,'),
        ('mqueue getattr /foo,'                                 , 'mqueue getattr /foo,'),
        ('mqueue (setattr getattr) 1234,'                       , 'mqueue (getattr setattr) 1234,'),
        ('mqueue wr label=tst 1234,'                            , 'mqueue wr label=tst 1234,'),
        ('mqueue wr  type=sysv   label=tst 1234,'               , 'mqueue wr type=sysv label=tst 1234,'),
        ('mqueue wr   type=posix label=tst /foo,'               , 'mqueue wr type=posix label=tst /foo,'),
    )

    def _run_test(self, rawrule, expected):
        self.assertTrue(MessageQueueRule.match(rawrule))
        obj = MessageQueueRule.parse(rawrule)
        clean = obj.get_clean()
        raw = obj.get_raw()

        self.assertEqual(expected.strip(), clean, 'unexpected clean rule')
        self.assertEqual(rawrule.strip(), raw, 'unexpected raw rule')

    def test_write_manually(self):
        obj = MessageQueueRule('setattr', 'posix', 'bar', '/foo', allow_keyword=True)

        expected = '    allow mqueue setattr type=posix label=bar /foo,'

        self.assertEqual(expected, obj.get_clean(2), 'unexpected clean rule')
        self.assertEqual(expected, obj.get_raw(2), 'unexpected raw rule')

    def test_write_invalid_access(self):
        obj = MessageQueueRule('setattr', 'posix', 'bar', '/foo')
        obj.access = ''
        with self.assertRaises(AppArmorBug):
            obj.get_clean()

    def test_write_invalid_type(self):
        obj = MessageQueueRule('setattr', 'posix', 'bar', '/foo')
        obj.mqueue_type = ''
        with self.assertRaises(AppArmorBug):
            obj.get_clean()

    def test_write_invalid_label(self):
        obj = MessageQueueRule('setattr', 'posix', 'bar', '/foo')
        obj.label = ''
        with self.assertRaises(AppArmorBug):
            obj.get_clean()

    def test_write_invalid_mqueue_name(self):
        obj = MessageQueueRule('setattr', 'posix', 'bar', '/foo')
        obj.mqueue_name = ''
        with self.assertRaises(AppArmorBug):
            obj.get_clean()


class MessageQueueIsCoveredTest(AATest):
    def test_is_covered(self):
        obj = MessageQueueRule(('create'), MessageQueueRule.ALL, 'f*', MessageQueueRule.ALL)
        self.assertTrue(obj.is_covered(MessageQueueRule(('create'), 'sysv', 'f*', '1234')))
        self.assertTrue(obj.is_covered(MessageQueueRule(('create'), 'posix', 'f*', MessageQueueRule.ALL)))
        self.assertTrue(obj.is_covered(MessageQueueRule(('create'), 'sysv', 'foo', MessageQueueRule.ALL)))
        self.assertTrue(obj.is_covered(MessageQueueRule(('create'), 'sysv', 'foo', '1234')))

    def test_is_not_covered(self):
        obj = MessageQueueRule(('getattr'), 'sysv', 'f*', '1234')
        self.assertFalse(obj.is_covered(MessageQueueRule(('create'), 'sysv', 'foo', MessageQueueRule.ALL)))
        self.assertFalse(obj.is_covered(MessageQueueRule(('getattr'), 'posix', 'foo', MessageQueueRule.ALL)))
        self.assertFalse(obj.is_covered(MessageQueueRule(('getattr'), 'sysv', 'bar', MessageQueueRule.ALL)))
        self.assertFalse(obj.is_covered(MessageQueueRule(('getattr'), 'sysv', 'foo', '123')))


class MessageQueueLogprofHeaderTest(AATest):
    tests = (
        ('mqueue,',                     [                               _('Access mode'), _('ALL'),         _('Type'), _('ALL'), _('Label'), _('ALL'), _('Message queue name'), _('ALL'), ]),
        ('mqueue (create,getattr) 12,', [                               _('Access mode'), 'create getattr', _('Type'), _('ALL'), _('Label'), _('ALL'), _('Message queue name'), '12', ]),
        ('mqueue write label=bar,',     [                               _('Access mode'), 'write',          _('Type'), _('ALL'), _('Label'), 'bar',    _('Message queue name'), _('ALL'), ]),
        ('mqueue write type=sysv,',     [                               _('Access mode'), 'write',          _('Type'), 'sysv',   _('Label'), _('ALL'), _('Message queue name'), _('ALL'), ]),
        ('mqueue read type=posix,',     [                               _('Access mode'), 'read',           _('Type'), 'posix',  _('Label'), _('ALL'), _('Message queue name'), _('ALL'), ]),
        ('deny mqueue read /foo,',      [_('Qualifier'), 'deny',        _('Access mode'), 'read',           _('Type'), _('ALL'), _('Label'), _('ALL'), _('Message queue name'), '/foo', ]),
        ('allow mqueue setattr,',       [_('Qualifier'), 'allow',       _('Access mode'), 'setattr',        _('Type'), _('ALL'), _('Label'), _('ALL'), _('Message queue name'), _('ALL'), ]),
        ('audit mqueue r label=ba 12,', [_('Qualifier'), 'audit',       _('Access mode'), 'r',              _('Type'), _('ALL'), _('Label'), 'ba',     _('Message queue name'), '12', ]),
        ('audit deny mqueue rw,',       [_('Qualifier'), 'audit deny',  _('Access mode'), 'rw',             _('Type'), _('ALL'), _('Label'), _('ALL'), _('Message queue name'), _('ALL'), ]),
    )

    def _run_test(self, params, expected):
        obj = MessageQueueRule.parse(params)
        self.assertEqual(obj.logprof_header(), expected)


class ModuleGlobTestAATest(AATest):
    def test_glob(self):
        self.assertEqual(MessageQueueRuleset().get_glob('mqueue create,'), 'mqueue,')


setup_all_loops(__name__)
if __name__ == '__main__':
    unittest.main(verbosity=1)
