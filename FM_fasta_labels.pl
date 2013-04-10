#!/usr/bin/env perl

=head1 NAME

FM_fasta_labels<.pl>

=head1 USAGE

FM_fasta_labels.pl [options -v,-d,-h] <ARGS>

=head1 SYNOPSIS

A very simple script - loop through a FASTA file and output another FASTA file with incremental integer indexes for labels.

=head1 AUTHOR

B<Adam Sardar> - I<adam.sardar@bristol.ac.uk>

=head1 COPYRIGHT

Copyright 2013 Gough Group, University of Bristol.

=cut

# Strict Pragmas
#----------------------------------------------------------------------------------------------------------------
use Modern::Perl;
#use diagnostics;

# Add Local Library to LibPath
#----------------------------------------------------------------------------------------------------------------
use lib "$ENV{HOME}/bin/perl-libs-custom";


# CPAN Includes
#----------------------------------------------------------------------------------------------------------------
=head1 DEPENDANCY
B<Getopt::Long> Used to parse command line options.
B<Pod::Usage> Used for usage and help output.
B<Data::Dumper> Used for debug output.
=cut
use Getopt::Long;                     #Deal with command line options
use Pod::Usage;                       #Print a usage man page from the POD comments after __END__
use Data::Dumper;                     #Allow easy print dumps of datastructures for debugging
#use XML::Simple qw(:strict);          #Load a config file from the local directory
use DBI;
use Supfam::Utils;


# Command Line Options
#----------------------------------------------------------------------------------------------------------------

my $verbose; #Flag for verbose output from command line opts
my $debug;   #As above for debug
my $help;    #Same again but this time should we output the POD man page defined after __END__
my $file;
my $outfile = 'IndexedFASTA.fa';

#Set command line flags and parameters.
GetOptions("verbose|v!"  => \$verbose,
           "debug|d!"  => \$debug,
           "help|h!" => \$help,
           "file|f=s" => \$file,
           "out|o:s" => \$outfile,
        ) or die "Fatal Error: Problem parsing command-line ".$!;

#Print out some help if it was asked for or if no arguments were given.
pod2usage(-exitstatus => 0, -verbose => 2) if $help;

# Main Script Content
#----------------------------------------------------------------------------------------------------------------

open OUTFILE, ">$outfile" or die $!."\t".$?;
open FASTA, "<$file" or die $!."\t".$?;
open INDEX, ">$outfile.index" or die $!."\t".$?;

my $CurrentFASTArecord; #FASTA record can be spread over severla lines as it is a TERRIBLE format.
my $RecordIndexTag;
my $index = 0;

while (my $line = <FASTA>){
	
	chomp($line);
	
	next if($line =~ m/^\s*$/ || $line =~ m/^#/); #Next if a blank line or comment line
	
	if($line =~ m/^>(.+)$/){
		
		unless($RecordIndexTag ~~ undef){
			#Print previous record
			print OUTFILE ">".$index."\n".$CurrentFASTArecord."\n";
			print INDEX $index."\t".$RecordIndexTag."\n";
			$index++;
		}
		
		#Reset variables for new record
		$RecordIndexTag = $1;
		$CurrentFASTArecord = undef;
		
	}else{
		
		$CurrentFASTArecord .= $line;
	}
	
	
}


close FASTA;
close OUTFILE;
close INDEX;


__END__
