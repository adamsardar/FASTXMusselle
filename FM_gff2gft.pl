#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

use File::Basename;
use Bio::FeatureIO;

my $inFile = shift;
print STDERR "Processing $inFile\n";
my ($name, $path, $suffix) = fileparse($inFile, qr/\.gff/);
my $outFile = $path . $name . ".gtf";

my $inGFF = Bio::FeatureIO->new( '-file' => "$inFile",
'-format' => 'GFF',
'-version' => 3 );
my $outGTF = Bio::FeatureIO->new( '-file' => ">$outFile",
'-format' => 'GFF',
'-version' => 2.5);

while (my $feature = $inGFF->next_feature() ) {

$outGTF->write_feature($feature);

}
