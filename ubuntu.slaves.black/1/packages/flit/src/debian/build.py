#!/usr/bin/env python3

# Symlink install flit & flit_core for development.
# Most projects can do the same with 'flit install --symlink'.
# But that doesn't work until Flit is installed, so we need some bootstrapping.

import argparse
import logging
import os
import os.path as osp
from pathlib import Path
import shutil
import sys

my_dir = Path(__file__).parent
os.chdir(str(my_dir))
sys.path.insert(0, 'flit_core')

from flit.install import Installer

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)

class DebianInstaller(Installer):
    def install_directly(self):
        """Install a module/package into package directory, and create its scripts.
        """
        dirs = self._get_dirs(user=self.user)
        dirs['purelib'] = 'debian/flit/' + dirs['stdlib'] + '/dist-packages'
        dirs['scripts'] = 'debian/flit'+ dirs['scripts']
        os.makedirs(dirs['purelib'], exist_ok=True)
        os.makedirs(dirs['scripts'], exist_ok=True)

        dst = osp.join(dirs['purelib'], osp.basename(self.module.path))
        if osp.lexists(dst):
            if osp.isdir(dst) and not osp.islink(dst):
                shutil.rmtree(dst)
            else:
                os.unlink(dst)

        # Install requirements to target environment
        # self.install_requirements()

        # Install requirements to this environment if we need them to
        # get docstring & version number.
        #if self.python != sys.executable:
        #    self.install_reqs_my_python_if_needed()

        src = str(self.module.path)
        if self.symlink:
            log.info("Symlinking %s -> %s", src, dst)
            os.symlink(osp.abspath(self.module.path), dst)
            self.installed_files.append(dst)
        elif self.pth:
            # .pth points to the the folder containing the module (which is
            # added to sys.path)
            pth_target = osp.dirname(osp.abspath(self.module.path))
            pth_file = pathlib.Path(dst).with_suffix('.pth')
            log.info("Adding .pth file %s for %s", pth_file, pth_target)
            with pth_file.open("w") as f:
                f.write(pth_target)
            self.installed_files.append(pth_file)
        elif self.module.is_package:
            log.info("Copying directory %s -> %s", src, dst)
            shutil.copytree(src, dst)
            self._record_installed_directory(dst)
        else:
            log.info("Copying file %s -> %s", src, dst)
            shutil.copy2(src, dst)
            self.installed_files.append(dst)

        scripts = self.ini_info.entrypoints.get('console_scripts', {})
        self.install_scripts(scripts, dirs['scripts'])

        self.write_dist_info(dirs['purelib'])

install_kwargs = {'user': False, 'symlink': False}
# Install flit_core
DebianInstaller.from_ini_path(
    my_dir / 'flit_core' / 'pyproject.toml', **install_kwargs
).install_directly()
print("Linked flit_core into site-packages.")

# Install flit
DebianInstaller.from_ini_path(
    my_dir / 'pyproject.toml', **install_kwargs
).install_directly()
print("Linked flit into site-packages.")
