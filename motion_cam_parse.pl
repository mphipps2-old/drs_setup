#!/usr/bin/perl

my $url="http://localhost:8082";
if ( $#ARGV == 0 )
{
    $url=$ARGV[0];
}

open ( S, "wget -O - -q $url |") || die " usage: cam_parse.pl URL-string, e.g. http://localhost:8081\n";

$FOUND_START = 0;

while ( $LINE=<S>)
{
    if ( $LINE =~ /--BoundaryString/ )
	{
	   # print "$LINE\n";
	    $junk = <S>;
	    $junk = <S>;
	    $junk = <S>;
	    last;
	}
}

while ( $LINE=<S>)
{

    if ( $LINE =~ /--BoundaryString/ )
    {
	close S;
	exit(0);
    }
    print  $LINE;
}
