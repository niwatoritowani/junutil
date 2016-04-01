#!/usr/bin/env python
# coding: UTF-8

import argparse
import sys
from os.path import basename, splitext, abspath, exists
from subprocess import Popen, PIPE, check_call
import re
import fileinput

def t(cmd):
    if isinstance(cmd, list):
        cmd = ' '.join(cmd)
    print "* " + cmd
    check_call(cmd, shell=True)

def nrrd_is_valid(nrrd):
    stdout, stderr = Popen('unu minmax %s' % nrrd, shell=True, stdout=PIPE,
                           stderr=PIPE).communicate()
    if 'trouble' in stdout:
        return False
    if 'trouble' in stderr:
        return False
    return True

def extract_line_in_file(afile, match_string):
    for line in fileinput.FileInput(afile):
        if match_string in line:
            print "extracted line: " + str(line)
            return line

def replace_line_in_file(afile, match_string, replace_with):
    for line in fileinput.FileInput(afile, inplace=1):   # what is inplace
        if match_string in line:
            line = replace_with
        print line,

def main():
    argparser = argparse.ArgumentParser(description="Centers a nrrd.")
    argparser.add_argument('-i', '--infile', help='a 3d or 4d nrrd image', required=True)
    argparser.add_argument('-o', '--outfile', help='a 3d or 4d nrrd image', required=True)
    argparser.add_argument('-r', '--reffile', help='a 3d or 4d nrrd image', required=True)
    args = argparser.parse_args()

    image_in = abspath(args.infile)
    image_out = abspath(args.outfile)
    image_ref = abspath(args.reffile)

    if not exists(image_in):
        print image_in + ' doesn\'t exist'
        sys.exit(1)
    if not nrrd_is_valid(image_in):
        print image_in + ' is not a valid nrrd'
        sys.exit(1)
    #if exists(args.outfile):
        #print args.outfile + ' already exists.'
        #print 'Delete it first.'
        #sys.exit(1)

    new_origin = extract_line_in_file(image_ref, "space origin: ")   
    t('unu save -e gzip -f nrrd -i %s -o %s' % (image_in, image_out))
    replace_line_in_file(image_out, "space origin: ", "%s" % (new_origin))

if __name__ == '__main__':
    main()
