#!/usr/bin/perl -w
#
# Take the trace output of LaTeX and tidy it up
#

use strict;

use Text::Wrap;


my %refs;
my @missing;

my $fileName = "Initial";
my $oldFileName = "";
my $pageNo = 0;
my $pageCount = 0;
my $opfile = "<unknown>";
my $orig;

select(STDERR);
$| = 1;

print "\n\n=====================================================\n";

my $lastWasOverfull = 0;
my $inLayout = 0;

while (<>) {
  $orig = $_;
#  print;
  # Remove self-agrandisements
  next if /^This is TeX/;
  next if /^Babel/;
  next if /^Document Class/;
  next if /^Style [Oo]ption/;
  next if /^LaTeX2e/;
  next if /^Package/;
  next if /^.PSTricks/;
  next if /^Writing glossary file/;
  next if /Empty \`thebibliography\'/;
  next if /^Transcript written/;
  next if /\/share\//;
  next if /\.epsf?>/;
  next if /V\d\d patch/;
  next if /1.79991pt/;
  next if /for immediate help/;

  print "---------------------------------------------\n"  if (/! LaTeX Error:/);


  if (/\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*/) {
      if ($inLayout) {
	  $inLayout = 0;
      }
      else {
	  $inLayout = 1;
      }
  }

  next if ($inLayout);


  if (0  && /(Ov|Und)erfull \\hbox/) {
      $lastWasOverfull = 1;
      next;
  }

  if ($lastWasOverfull) {
      $lastWasOverfull = 0 if /^\s*$/;
      next;
  }

  # Look for the /output written message - it confuses the filename handling
  if (/^Output written on (\w+).dvi \((\d+) page/) {
    $pageCount = $2;
    $opfile = $1;
    next;
  }

  # Remove all the stupid font and package load lines
  next if (m!/lib/texmf/texmf!);

  # Look for file names

  while (m!\((tmp/)?([a-zA-Z][\w]+\.\w+)!) {
    $fileName = $2;
    s{\((tmp/)?[a-zA-Z][\w]+\.\w+}{};
  }

  # Accumulate undefined references
  if (/Reference \`(.*?)\' on page (\d+|[ivx]+)/) {
    $refs{$1} = $2;
    $_ = <> unless (/undefined on line \d+\./);
    next;
  }

  # Check for 'Missings'
  if (/\*\*\*\* (Missing|Check) (.*)/) {
    push @missing, [$fileName, $2];
  }

  # Remove dangling parens (from file names with errors, and
  # those pesky page numbers (but remember the last page

  my $doit = 0;
  $doit = 1 if (/108/);

  while (/\[(\d+)\]/) {
    $pageNo = $1;
    s/\[\d+\]//;
  }

  s/\[\]//g;

  s/^(\s*\)\s*)+//g;

  # Remove blank lines
  next if (/^\s*$/);

  # Otherwise print it out.

  if ($fileName ne $oldFileName) {
    print "\n$fileName:\n";
    $oldFileName = $fileName;
  }
#  print "--- ",$orig;
  print sprintf("%3d: ", $pageNo), "   $_";
}

# At end print any undefined references

my @keys = sort keys %refs;

if (@keys) {
  print wrap("\nUndefined references: ", "    ", join(", ", @keys)), "\n";
}

if (@missing) {
  print "\nMissing things:\n";
  for my $m (@missing) {
    my ($file, $what) = @$m;
    print "    $file:\t$what\n";
  }
}

print "\n$pageCount pages written to $opfile\n";
print "\n=====================================================\n";
