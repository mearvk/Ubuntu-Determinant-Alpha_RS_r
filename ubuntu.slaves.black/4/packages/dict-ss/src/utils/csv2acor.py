#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Copyright 2005, Søren Thing Pedersen stp@things.dk, Licensed under LGPL

import os, sys, zipfile, zlib, csv

SentenceExceptList = 'SentenceExceptList.csv'
WordExceptList = 'WordExceptList.csv'
DocumentList = 'DocumentList.csv'

manifest = """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE manifest:manifest PUBLIC "-//OpenOffice.org//DTD Manifest 1.0//EN" "Manifest.dtd">
<manifest:manifest xmlns:manifest="http://openoffice.org/2001/manifest">
 <manifest:file-entry manifest:media-type="" manifest:full-path="/"/>
 <manifest:file-entry manifest:media-type="text/xml" manifest:full-path="DocumentList.xml"/>
 <manifest:file-entry manifest:media-type="text/xml" manifest:full-path="WordExceptList.xml"/>
 <manifest:file-entry manifest:media-type="text/xml" manifest:full-path="SentenceExceptList.xml"/>
</manifest:manifest>"""

fileheader = """<?xml version="1.0" encoding="UTF-8"?>

<block-list:block-list xmlns:block-list="http://openoffice.org/2001/block-list">"""

filefooter = '</block-list:block-list>'

class calc(csv.Dialect):
    delimiter = ','
    quotechar = '"'
    doublequote = False
    quoting = csv.QUOTE_ALL
    escapechar = '\\'
    skipinitialspace = True
    lineterminator = '\r\n'
    
def zip_dir_into_file(dir, file):
	zfobj = zipfile.ZipFile(file, 'w', zipfile.ZIP_DEFLATED)
	for root, dirs, files in os.walk(dir):
		for thisfile in files:
			# print os.path.join(root,thisfile)
			zfobj.write(os.path.join(root, thisfile), os.path.join(root, thisfile).replace(dir, "")[1:])
	zfobj.close()

if len(sys.argv) != 2:
	print 'Usage: '+sys.argv[0]+' destinationfile'
else:
	destinationfile = sys.argv[1]
	tempdir = destinationfile+'_tmp'
	if os.path.exists(SentenceExceptList) and os.path.exists(WordExceptList) and os.path.exists(DocumentList):
		if not (os.path.exists(tempdir)):
			os.mkdir(tempdir, 0777)
		if not (os.path.exists(tempdir+'/Meta-inf/')):
			os.mkdir(tempdir+'/Meta-inf/', 0777)
			
		manifestfile = open(os.path.join(tempdir+'/Meta-inf/', 'manifest.xml'), 'wb')
		manifestfile.write(manifest)
		manifestfile.close()
		
		mimetypefile = open(os.path.join(tempdir, 'mimetype'), 'wb')
		mimetypefile.write('')
		mimetypefile.close()
		
		DocumentListfile = open(os.path.join(tempdir, 'DocumentList.xml'), 'wb')
		DocumentListfile.write(fileheader+"\n")
		csvreader = csv.reader(file(DocumentList), calc)
		for row in csvreader:
			line = '  <block-list:block block-list:abbreviated-name="'+row[0]+'" block-list:name="'+row[1]+'"/>'+"\n";
			DocumentListfile.write(line)
		DocumentListfile.write(filefooter+"\n")
		DocumentListfile.close()
		
		SentenceExceptListfile = open(os.path.join(tempdir, 'SentenceExceptList.xml'), 'wb')
		SentenceExceptListfile.write(fileheader+"\n")
		csvreader = csv.reader(file(SentenceExceptList), calc)
		for row in csvreader:
			line = '  <block-list:block block-list:abbreviated-name="'+row[0]+'"/>'+"\n";
			SentenceExceptListfile.write(line)
		SentenceExceptListfile.write(filefooter+"\n")
		SentenceExceptListfile.close()
		
		WordExceptListfile = open(os.path.join(tempdir, 'WordExceptList.xml'), 'wb')
		WordExceptListfile.write(fileheader+"\n")
		csvreader = csv.reader(file(WordExceptList), calc)
		for row in csvreader:
			line = '  <block-list:block block-list:abbreviated-name="'+row[0]+'"/>'+"\n";
			WordExceptListfile.write(line)
		WordExceptListfile.write(filefooter+"\n")
		WordExceptListfile.close()
		
		zip_dir_into_file(tempdir, destinationfile)
	else:
		print "SentenceExceptList.csv, WordExceptList.csv or DocumentList.csv missing!"
