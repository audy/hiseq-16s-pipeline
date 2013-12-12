#!/usr/bin/env python

import argparse
import string

from itertools import izip
from collections import defaultdict

import logging

from Bio import SeqIO

def parse_args():
    ''' parse arguments '''

    # remove command name.
    parser = argparse.ArgumentParser()
    parser.add_argument('--barcodes')
    parser.add_argument('--left-reads')
    parser.add_argument('--right-reads')
    parser.add_argument('--barcode-reads')
    parser.add_argument('--output', default='/dev/stdout')
    parser.add_argument('--revcomp-barcode', default=False, action='store_true')
    parser.add_argument('--bc-seq-proc', default=None)
    parser.add_argument('--header-format', default='default')
    parser.add_argument('--output-format', default='fastq')

    return parser.parse_args()


class DemultiplexedSequenceEmitter(object):

    def __init__(self, **kwargs):
        ''' Create a new DemultiplexedSequenceEmitter given
            Three sequence files and a list of barcodes

            >>> emitter = DemultiplexedSequenceEmitter(
            ...             left_handle=left_handle,
            ...             barcode_handle=barcode_handle,
            ...             right_handle=right_handle,
            ...             barcodes=barcodes
            ...           )

            >>> for l, b, r in emitter:
            ...     print b
        '''

        self.left_handle = kwargs['left_handle']
        self.right_handle = kwargs['right_handle']
        self.barcode_handle = kwargs['barcode_handle']
        self.barcodes = kwargs['barcodes']

        self.left_records = SeqIO.parse(self.left_handle, 'fastq')
        self.barcode_records = SeqIO.parse(self.barcode_handle, 'fastq')
        self.right_records = SeqIO.parse(self.right_handle, 'fastq')

        self.stats = defaultdict(int)

        #
        # a lambda for preprocessing barcode sequences
        # can be used to get around problems with barcodes
        # having extra nucleotides
        #
        # example: barcode_proc = lambda k: k[0:7]
        # will only use first 7 characters of the barcode
        #

        self.barcode_proc = eval(kwargs.get('barcode_proc', None))


    def __iter__(self):
        ''' Iterates over triplets of sequence files yielding only
            records that match a barcode sequence in the given
            barcodes dictionary.
        '''

        for l, b, r in izip(self.left_records, self.barcode_records, self.right_records):

            # preprocess barcode, or don't
            if self.barcode_proc != None:
                b = self.barcode_proc(b)

            # if barcode is a match, yield left, barcode and right
            # SeqIO records.
            if str(b.seq) in self.barcodes:
                self.stats['matched'] += 1
                yield (l, b, r)
            else:
                self.stats['skipped'] += 1
                continue


def load_barcodes(handle, revcomp=True):
    ''' Loads barcodes file into dictionary where
        'barcode_sequence': 'sample_id', ...

        File looks like:
        name,barcode_sequence
        ...
        name,barcode_sequence

        >>> barcodes = load_barcodes('barcodes.csv', revcomp=True)
    '''

    REVCOMP = string.maketrans('GATCNgatcn', 'CTAGNctagn')

    barcodes = {}

    logging.info('loading barcodes from %s with revcomp=%s' % (handle.name, revcomp))

    for line in handle:
        line = line.strip().split(',')
        name, bc = line[0], line[1]
        if revcomp:
            bc = bc[::-1].translate(REVCOMP)
        barcodes[bc] = name

    logging.info('loaded %s barcodes' % len(barcodes))

    return barcodes


def setup_logging(logfile='/dev/stderr', verbose=False):

    if verbose:
        level = logging.DEBUG
    else:
        level = logging.INFO

    return logging.basicConfig(filename=logfile, level=level)


def reformat_header(seq_record, format=None, info=None):

    if format == 'default':
        seq_record.description = ''
        seq_record.id = '%s_S_%s' % (info['sample_id'], info['index'])
    return seq_record


def main(logger=None):
    # parse arguments
    args = parse_args()

    setup_logging()

    # setup iterator stream.
    with open(args.barcodes) as handle:
        barcodes = load_barcodes(handle)

    left_handle = open(args.left_reads)
    right_handle = open(args.right_reads)
    barcode_handle = open(args.barcode_reads)

    emitter = DemultiplexedSequenceEmitter(
                left_handle=left_handle,
                barcode_handle=barcode_handle,
                right_handle=right_handle,
                barcodes=barcodes,
                barcode_proc=args.bc_seq_proc)

    output_handle = open(args.output, 'w')

    index = 0
    for l, b, r in emitter:
        index += 1
        sample_id = barcodes[str(b.seq)]

        l = reformat_header(l, format=args.header_format, info={'sample_id': sample_id,
            'index': index})

        output_handle.write(l.format(args.output_format))
        output_handle.write(r.format(args.output_format))

    logging.info('matched %s pairs' % index)

    output_handle.close()
