#! /usr/bin/env python

import os
import shutil
import time
import re
import argparse
import sys
from sh import rsync

#Command-line arguments
parser = argparse.ArgumentParser(
    description=__doc__)
parser.add_argument("-b", "--backup", help="Specify the directory you would like to have backed up.")
parser.add_argument("-d", "--destination",  help="Specify the directory where the backup will be stored.")

args = parser.parse_args()

if len(sys.argv) < 2:
    parser.print_help()
    sys.exit(1)


#Defining variables
backup_path = args.backup
backup_to_path = args.destination


#backup_path = raw_input("What do you want backed up today?\n")

if not os.path.exists(backup_path):
    print backup_path, "does not exist"
    exit(1)

if os.path.islink(backup_path):
    print backup_path, "contains a symlink."
    exit(1)

#backup_to_path = raw_input("Where would you like to back this up to?\n")

if not os.path.exists(backup_to_path):
    print backup_to_path, "does not exist"
    exit(1)

if os.path.islink(backup_to_path):
    print backup_to_path, "contains a symlink."
    exit(1)

rsync("-Pavhu", "--exclude=lost+found", "--exclude=/sys", "--exclude=/tmp", "--exclude=/proc",   "--exclude=/mnt", "--exclude=/dev", "--exclude=/backup", backup_path, backup_to_path)
