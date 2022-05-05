#!/usr/bin/env python3
"""vifm mediaprg for Mac OSX"""

import argparse
import plistlib
import subprocess
import sys

DISKUTIL = "diskutil"


def make_parser():
    """Return arparse.ArgumentParser instance"""
    parser = argparse.ArgumentParser(
        description=__doc__,  # printed with -h/--help
        # Don't mess with format of description
        formatter_class=argparse.RawDescriptionHelpFormatter,
        # To have --help print defaults with trade-off it changes
        # formatting, use: ArgumentDefaultsHelpFormatter
    )
    subparsers = parser.add_subparsers(help='command')

    parser_list = subparsers.add_parser('list', help='list mounted media')
    parser_list.set_defaults(func=list)

    parser_mount = subparsers.add_parser('mount', help='mount a device')
    parser_mount.add_argument("device", metavar="device", type=str, nargs=1,
                              help="device to mount")
    parser_mount.set_defaults(func=mount)

    parser_unmount = subparsers.add_parser('unmount',
                                           help='unmount given mount point')
    parser_unmount.add_argument("path", metavar="path", type=str, nargs=1,
                                help="path to unmount")
    parser_unmount.set_defaults(func=unmount)

    return parser


def list(args):
    """List media"""
    try:
        # Use '-plist' to get XML output
        output = subprocess.check_output(
            [DISKUTIL, "list", "-plist"])
    except subprocess.CalledProcessError:
        print("Failed to execute '{}'".format(DISKUTIL), file=sys.stderr)
        return(1)
    root = plistlib.loads(output)
    for disk in root["AllDisksAndPartitions"]:
        # By experimentation, these seem to be root and other uninteresting
        # disks
        if disk["Content"] == "GUID_partition_scheme":
            continue
        if "Partitions" in disk:
            for partition in disk["Partitions"]:
                print_disk_or_partition(partition)
        else:
            print_disk_or_partition(disk)
    return(0)


def print_disk_or_partition(node):
    """Given a PList node, print the associated disk or partition"""
    print("device=/dev/" + node["DeviceIdentifier"])
    try:
        print("label=" + node["VolumeName"])
    except KeyError:
        pass
    try:
        print("mount-point=" + node["MountPoint"])
    except KeyError:
        # Unmounted disk
        pass


def mount(args):
    """Mount a device"""
    device = args.device[0]
    try:
        subprocess.check_call([DISKUTIL, "mount", device])
    except OSError:
        print("Failed to execute {}".format(DISKUTIL), file=sys.stderr)
        return(1)
    except subprocess.CalledProcessError:
        # Trust diskutil to have output a useful error message
        return(1)
    return(0)


def unmount(args):
    """Unmount given mount point"""
    path = args.path[0]
    try:
        subprocess.check_call([DISKUTIL, "unmount", path])
    except OSError:
        print("Failed to execute {}".format(DISKUTIL), file=sys.stderr)
        return(1)
    except subprocess.CalledProcessError:
        # Trust diskutil to have output a useful error message
        return(1)
    return(0)


def main(argv=None):
    parser = make_parser()
    args = parser.parse_args(argv if argv else sys.argv[1:])
    return(args.func(args))


if __name__ == "__main__":
    sys.exit(main())
