"""
Send reports about ubuntu-desktop-installer to the correct Launchpad project.

"""
import os

from apport import hookutils


def add_info(report, ui):

    udilog = os.path.realpath("/var/log/installer/ubuntu_desktop_installer.log")
    hookutils.attach_file_if_exists(report, udilog, "UdiLog")

    report['SourcePackage'] = 'ubuntu-desktop-installer'
    # rewrite this section so the report goes to the project in Launchpad
    report[
        "CrashDB"
    ] = """{
       "impl": "launchpad",
       "project": "ubuntu-desktop-installer",
       "bug_pattern_url": "http://people.canonical.com/~ubuntu-archive/bugpatterns/bugpatterns.xml"
    }"""

    subiquitylog = os.path.realpath("/var/log/installer/subiquity-server-debug.log")
    hookutils.attach_file_if_exists(report, subiquitylog, "SubiquityLog")

    hookutils.attach_file_if_exists(
        report, "/var/log/installer/subiquity-curtin-install.conf", "CurtinConfig"
    )
    hookutils.attach_file_if_exists(
        report, "/var/log/curtin/install.log", "CurtinLog"
    )
    hookutils.attach_file_if_exists(
        report, "/var/log/curtin/curtin-error-logs.tar", "CurtinError"
    )

    hookutils.attach_file_if_exists(
        report, "/var/log/installer/block/probe-data.json", "ProbeData"
    )
