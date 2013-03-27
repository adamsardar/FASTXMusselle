#!/usr/bin/env python

from os.path import join as joinp
from Bio import SeqIO
import argparse

def main():

	parser = argparse.ArgumentParser(description='Loop through a file and only print out reads that are greater than threshold. Requires the biopython  and argparse modules to be installed.')
		
	parser.add_argument('--file', '-f', metavar='FILE', required=True, type=argparse.FileType('r'), dest='InputFile', help='File to trim reads of')
	parser.add_argument('--output', '-o', metavar='OUTPUT', required=False, dest='Output', default='LongReads.fastq', type=argparse.FileType('w'), help='Output read file')
	parser.add_argument('--length', '-l', metavar='LENGTH', required=False, dest='Length', default=30, type=int, help='Minimum number of nucleotides in read')

	args = parser.parse_args()

	Reads = SeqIO.parse(args.InputFile, 'fastq')

	# Generator to iterate through records and only return those that satisfy if ...
	record_genetor = (rec for rec in Reads if len(rec) > args.Length)

	numwritten = SeqIO.write(record_genetor, args.Output, 'fastq')

	print 'Trimmed {0} down to {1} reads'.format(args.InputFile, numwritten)
	

if __name__ == "__main__":
	main()