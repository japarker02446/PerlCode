#!usr/bin/perl
# 
# quickFreeEnergy.pl
# 
# Jefferson A. Parker, Febit Inc.
# Copyright 2009, all rights reserved
# 
# Calculate the Nearest Neighbor free energy at 37C and 1M NaCl for
# input sequences.
# 
# Suppress 'Use of uninitialized value' warning messages.
no warnings 'uninitialized';

# Initialize libraries
use lib "/Users/jeffersonparker/perl/lib/perl5/site_perl/";
use Bio::JParker::DnaThermodynamics;
use Bio::JParker::ProbeDesign;
use Bio::JParker::Shared;
use Getopt::Std;

getopt(i);

my $inputDir = Bio::JParker::Shared::whereisDirectory('input');
my $outputDir = Bio::JParker::Shared::whereisDirectory('output');

my $inputFile = "$inputDir"."\/$opt_i";
my $outputFile = "$outputDir"."\/$opt_i"."_freeEnergy\.txt";

open (OUT, ">$outputFile") or die "Cannot open file $outputFile: $!\n";
print OUT "Name\tSequence\tTm \(C\)\tdG \(NN 1M\)\n";

open (IN, $inputFile) or die "Cannot open file $inputFile:$!\n";
while (<IN>){
	chomp ($fileLine = $_);
	my ($probeName, $sequence1) = split (/\t/, $fileLine, 2);
	my $sequence2 = Bio::JParker::ProbeDesign::reverseComplement($sequence1); 
	my ($tm, $dG) = Bio::JParker::DnaThermodynamics::calcDnaTm($sequence1, $sequence2, 1.35 * 10**-5, 1.35 * 10**-5, 0.0945);
	print OUT "$probeName\t$sequence1\t",sprintf("%.2f", $tm), "\t", sprintf("%.2f", $dG), "\n";
	print "$probeName\t$sequence1\t",sprintf("%.2f", $tm), "\t", sprintf("%.2f", $dG), "\n";
}
close (IN);
close (OUT);