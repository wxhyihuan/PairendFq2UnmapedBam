#!/usr/bin/perl
######################################
# Creator Name: Wangxh
# Email Add:    wxh244295043[AT]qq.com
# convertfq2baminfotosamplebamlists.pl
######################################
use strict;
use warnings;
use File::Basename;
use Cwd qw(abs_path);
use Getopt::Long;

#un maped bams  info, sampleid readgreoup unmapedbam
my $infile = abs_path( $ARGV[0] );
open In , $infile or die "Can not open file $infile";
my %sample_bamsinfo;
while (<In>) {
	chomp;
	next if /^#/;
	my @tmp=split( /\t/ );
	my $samplename=$tmp[0];
	if ( !exists $sample_bamsinfo{$samplename} ){
		$sample_bamsinfo{$samplename} = $tmp[-1];
	}else{
		$sample_bamsinfo{$samplename} = $sample_bamsinfo{$samplename}."\n".$tmp[-1];
	}
}
close In;

foreach my $samplename (keys %sample_bamsinfo){
	open Out,">$samplename.unmapedbams.list" or die "Can not open file $samplename.unmapedbams.list\n";
	print Out $sample_bamsinfo{$samplename}."\n";
	close Out;
}

