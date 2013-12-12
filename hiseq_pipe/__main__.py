import sys

import demultiplexer

def main():

    command = sys.argv[1]
    del sys.argv[1] # remove command name so argparse works.

    if command == 'help':
        print 'coming soon!'
    elif command == 'demultiplex':
        demultiplexer.main()


if __name__ == '__main__':
    main()
