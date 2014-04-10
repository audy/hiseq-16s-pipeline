# HPC OTU Pipeline

## Requirements

1. Python 2.7
2. BioPython `pip install bio`
3. USEARCH

## Methods

In a nutshell...

```bash
demultiplex \
  | trim \
  | reverse complement right read \
  | convert to fasta format \
  | break sequences into chunks \
  | query reads against GreenGenes using USEARCH (map) \
  | combine uc files into a single CSV file (reduce)
```

- All of the above steps except for the last are streamed using UNIX pipes.
- Query jobs are distrubted automatically by the SGE cluster.
- Checks are in place to ensure jobs completed successfully.
- There are scripts to automatically retry failed jobs.

## Usage

All scripts located in `bin/`. Move to `$PATH` if you so desire.

1. `hp-label-by-barcode`
2. `hp-split-for-array`
3. (trimming/converting to FASTA)
4. `hp-split-for-array`
5. `qsub ... misc/usearch_array.qsub`

## License

The MIT License (MIT)

Copyright (c) 2013-2014 Austin G. Davis-Richardson

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
