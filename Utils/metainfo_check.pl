#!/usr/bin/perl
######################################
# Creator Name: Wangxh
# Email Add:    wxh244295043[AT]qq.com
# metainfo_check.pl
######################################
use strict;
use warnings;
use File::Basename;
use Cwd qw(abs_path);
use Getopt::Long;

my $infile =abs_path($ARGV[0]);
my $outfile =abs_path($ARGV[1]);
open In , $infile or die "Can not open file $infile";
open Out , ">$outfile" or die "Can not open file $outfile";
while(<In>){
	chomp;
	next if /^#/;
	print Out $_."\n";
}
close In;
close Out;