import sys

import demultiplexer


def main():


    commands = {
            'demultiplex': demultiplexer.main,
            }

    try:
        command = sys.argv[1]
        del sys.argv[1]
    except IndexError:
        command = None


    if command not in commands:
        print 'unknown command: %s' % command
        print 'available commands:\n'
        for command in commands:
            print command
        quit(-1)
    else:
        command_function = commands[command]

    command_function()

if __name__ == '__main__':
    main()
