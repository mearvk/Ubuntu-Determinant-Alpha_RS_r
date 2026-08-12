from distutils.core import setup
from DistUtilsExtra.command import *
import glob

setup(
    name = 'adium-theme-ubuntu',
    version = '0.3.4',
    data_files=[('share/adium/message-styles/ubuntu.AdiumMessageStyle/Contents',
                 glob.glob('ubuntu.AdiumMessageStyle/Contents/Info.plist')),
		('share/adium/message-styles/ubuntu.AdiumMessageStyle/Contents/Resources',
                 glob.glob('ubuntu.AdiumMessageStyle/Contents/Resources/*.*')),
		('share/adium/message-styles/ubuntu.AdiumMessageStyle/Contents/Resources/balloons',
                 glob.glob('ubuntu.AdiumMessageStyle/Contents/Resources/balloons/*.*')),
		('share/adium/message-styles/ubuntu.AdiumMessageStyle/Contents/Resources/corners',
                 glob.glob('ubuntu.AdiumMessageStyle/Contents/Resources/corners/*.*')),
		('share/adium/message-styles/ubuntu.AdiumMessageStyle/Contents/Resources/images',
                 glob.glob('ubuntu.AdiumMessageStyle/Contents/Resources/images/*.*')),
		('share/adium/message-styles/ubuntu.AdiumMessageStyle/Contents/Resources/Incoming',
                 glob.glob('ubuntu.AdiumMessageStyle/Contents/Resources/Incoming/*.*')),
		('share/adium/message-styles/ubuntu.AdiumMessageStyle/Contents/Resources/Outgoing',
                 glob.glob('ubuntu.AdiumMessageStyle/Contents/Resources/Outgoing/*.*')),

               ],
    cmdclass = { "build" : build_extra.build_extra }
)
