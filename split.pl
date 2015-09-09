#!/usr/bin/perl

use strict;
use File::Copy;
use File::Path;
use Encode qw(decode);

$\ = "\n";
$, ="\t=>\t";
my $dir = shift @ARGV || '.';
binmode(STDOUT, ":utf8");


opendir DIR, $dir or warn qq|'Não foi possivel abrir o directorio corrente'|;

#my %files = map {s/[^0-9]+(?=\.)//; ($_ => 1)} grep {/\.jpg/i} grep { -f $_} readdir DIR;
my @files = map {decode("utf8",$_)} grep {/\.mp3$/i} readdir DIR;
my %prefix = ();
foreach(@files){
	/^(?:-|_)?(\X)/i;
	my $i = uc $1;
	$prefix{$i} //= [];
	push $prefix{$i}, $_; 
}

$dir =~ s/\/$|\$//;

my $err;
foreach (sort keys %prefix){
	while (my $file = pop $prefix{$_}){
		my $sdir = "$dir/$_";
		-d $sdir or mkpath($sdir, {
			verbose => 3,
			error => \$err,
		});
		$err and @$err and die "@$err";
		print "Move $dir/$file", "$sdir/$file";
		move("$dir/$file", "$sdir/$file");
	}
}

#my %files = map {s/[^0-9]+(?=\.)//; ($_ => 1)} grep {/\.mp3$/i} readdir DIR;
# my $err;
# -d $orig or mkpath($orig, {
# 	verbose => 3,
# 	error => \$err,
# });

# if ($err and @$err) {
# 	for my $diag (@$err) {
# 		my ($file, $message) = %$diag;
# 		if ($file eq '') {
# 			print "Erro: $message\n";
# 		}else {
# 			print "Problemas ao criar o directório $file: $message\n";
# 		}
# 	}
# }

# foreach (keys %files){
# 	my $f1 = "$dir/../$_";
# 	my $f2 = $f1;
# 	my $d1 = "$orig/$_";
# 	print qq|$f1 => $d1|;
# 	move($f1,$d1);
# 	$f2 =~ s/\.jpg$/\.NEF/i;
# 	my $d2 = $d1;
# 	$d2 =~ s/\.jpg$/\.NEF/i;
# 	print qq|$f2 => $d2|;
# 	move($f2, $d2);
# }
