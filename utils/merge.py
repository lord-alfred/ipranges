import argparse

import netaddr


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Merge IP addresses into the smallest possible list of CIDRs.')
    parser.add_argument('--source', nargs='?', type=argparse.FileType('r'), required=True, help='Source file path')
    args = parser.parse_args()

    for addr in netaddr.cidr_merge(args.source.readlines()):
        print(addr)
