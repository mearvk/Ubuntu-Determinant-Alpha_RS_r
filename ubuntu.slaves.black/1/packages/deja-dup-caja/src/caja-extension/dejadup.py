# -*- coding: utf-8 -*-
# Deja Dup Caja 0.0.9
# Copyright (C) 2015-2019 Marcos Alvarez Costales https://launchpad.net/~costales
# Copyright (C) 2015 Ubuntu MATE Project     https://ubuntu-mate.org/
#
# Deja Dup Caja is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Deja Dup Caja is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Deja Dup Caja; if not, see http://www.gnu.org/licenses
# for more information.

import gettext, subprocess, os, ast
# Python 2 or 3
try:
    from urllib import unquote
except ImportError:
    from urllib.parse import unquote

from gi.repository import Caja, GObject

# i18n
gettext.textdomain('deja-dup-caja')
_ = gettext.gettext


class DejaDup:
    def __init__(self):
        pass

    def _run_cmd(self, cmd, background=True):
        """Run command into shell"""
        if background:
            proc = subprocess.Popen(cmd, shell=False)
        else:
            proc = subprocess.Popen(cmd, shell=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout,stderr = proc.communicate()
            return stdout,stderr

    def backup(self, item):
        """Call to backup"""
        self._run_cmd(['deja-dup', '--backup', item])

    def restore(self, item):
        """Call to restore"""
        self._run_cmd(['deja-dup', '--restore', item])

    def get_dejadup_paths(self, type_list):
        """Get include/exclude paths from Deja Dup"""
        new_paths = []

        cmd = ['gsettings', 'get', 'org.gnome.DejaDup', type_list]
        stdout,stderr = self._run_cmd(cmd, False)

        # Error
        if stderr:
            return []
        # OK
        stdout_str = [stdout][0].decode()    # With python3 needs this convertion
        paths = ast.literal_eval(stdout_str) # Convert shell dump to list
        for path in paths:
            try: # Is a shell variable?
                new_paths.append(os.environ[path.replace('$', '')])
            except:
                new_paths.append(path)

        return new_paths


class Utils:
    def __init__(self):
        pass

    def get_filepath(self, items):
        """Get just the path from a complete path and filename"""
        try:
            item = items[0]
        except:
            item = items
        return unquote(item.get_uri()[7:])

    def search_paths(self, item_path, paths):
        """Check if at least one path is in the pattern path"""
        for path in paths:
            if path in item_path:
                return True
        return False


class DejaDupCaja(GObject.GObject, Caja.MenuProvider):
    def __init__(self):
        self.dejadup = DejaDup()
        self.utils = Utils()

    def _backup_activate(self, menu, item):
        """Backup file or folder"""
        self.dejadup.backup(item)

    def _restore_activate(self, menu, item):
        """Restore file or folder"""
        self.dejadup.restore(item)

    def _previous_checks(self, items):
        """Checks before generate the contextual menu"""
        # Show only for 1 item selected
        if len(items) != 1:
            return False
        item = items[0]

        # Check exists yet
        if item.is_gone():
            return False

        # Only handle files
        if item.get_uri_scheme() != 'file':
            return False

        return True

    def get_background_items(self, window, current_folder):
        """Caja invoke this when user clicks in an empty area"""
        Menu = Caja.MenuItem(
                name="DejaDupCajaMenu::Restore",
                label=_("Revert to Previous Version..."),
                icon="deja-dup")

        # Get complete path
        item = self.utils.get_filepath(current_folder)

        Menu.connect('activate', self._restore_activate, item)
        return [Menu]

    def get_file_items(self, window, selected_items):
        """Caja invoke this when user clicks in a file or folder"""
        if not self._previous_checks(selected_items):
            return

        # Get complete path
        item = self.utils.get_filepath(selected_items)

        # Get paths
        include_paths = self.dejadup.get_dejadup_paths('include-list')
        exclude_paths = self.dejadup.get_dejadup_paths('exclude-list')

        # Check backup or restore menu entry
        # Is the path into the exclude? > Backup
        if self.utils.search_paths(item, exclude_paths):
            backup = True
        # Is the path into the include? > Restore
        elif self.utils.search_paths(item, include_paths):
            backup = False
        # Not include/exclude > Backup
        else:
            backup = True

        # Generate menu and trigger event
        if backup:
            Menu = Caja.MenuItem(
                name="DejaDupCajaMenu::Backup",
                label=_("Backup..."),
                icon="deja-dup"
            )
            Menu.connect('activate', self._backup_activate, item)
        else:
            Menu = Caja.MenuItem(
                name="DejaDupCajaMenu::Restore",
                label=_("Revert to Previous Version..."),
                icon="deja-dup"
            )
            Menu.connect('activate', self._restore_activate, item)
        return [Menu]
