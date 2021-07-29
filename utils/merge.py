import argparse

import netaddr


def read(fh):
    for line in fh:
        yield line.rstrip()

    fh.close()


def merge(fh):
    for addr in netaddr.cidr_merge(read(fh)):
        print(addr)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Merge IP addresses into the smallest possible list of CIDRs.')
    parser.add_argument('--source', nargs='?', type=argparse.FileType('r'), required=True, help='Source file path')
    args = parser.parse_args()

    merge(args.source)
