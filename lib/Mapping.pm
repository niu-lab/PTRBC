package Mapping;

use 5.006;
use strict;
use warnings;

use Carp;
use Getopt::Long;
use IO::File;
use FileHandle;
our $VERSION = '0.01';

sub new {
	my $class = shift;
	my $this = {};
	$this->{'input_dir'} = undef;
	$this->{'dic'} = undef;
	$this->{'raw'} = undef;
	$this->{'output_dir'} = undef;
	bless $this, $class;
	$this->process();
	return $this;
}

sub process {
	my $this = shift;
	my ( $help, $options );
	unless ( @ARGV ) { die $this->help_text();}
	$options = GetOptions(
		'input_dir=s' => \$this->{'input_dir'},
		'dic=s' => \$this->{'dic'},
		'raw=s' => \$this->{'raw'},
		'output_dir=s' => \$this->{'output_dir'},
		'help' => \$help,
	);
	if ( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
	unless ( $this->{'dic'} ) { warn 'You must provide a mapping dictionary !' , "\n"; die help_text(); }
	unless ( $this->{'raw'} ) { warn 'You must provide a valid to be cleaned data file ! ' , "\n"; die help_text(); }
	unless ( -d $this->{'input_dir'} ) { warn 'You must provide an input directory !' , "\n"; die help_text();}
	unless ( -d $this->{'output_dir'} ) { warn 'You must provide an output directory !' , "\n"; die help_text();}
	my $fh = new FileHandle;
	my $fo = new FileHandle;
	die "Could not open the input dictionary file !\n " unless ( $fh->open("<$this->{'input_dir'}/$this->{'dic'}") );
	my %dic;
	while( my $ll = $fh->getline ){
		chomp( $ll );
		unless($ll =~ /^#/){
        		my @line = split (/\t/, $ll, -1);
        		$dic{$line[0]} = $line[1];
        	}
	
	}
	$fh->close();
	die "Could not open the raw data file !\n" unless ( $fh->open("<$this->{'input_dir'}/$this->{'raw'}") );
	my $temp=$this->{'raw'};
	$temp=~s/\.xlsx//g;
	die "Could not open the output file !\n" unless ( $fo->open(">$this->{'output_dir'}/${temp}_mapped.xlsx") );
	while( my $ll = $fh->getline ){
		chomp( $ll );
		my @line = split (/\t/, $ll, -1);
		my $count=0;
		foreach my $ele (@line){
                if(exists $dic{$ele}){
                        $line[$count]=$dic{$ele};
		}
		$count++; # The current property index
        	}
        	my $out = join "\t", @line;
        	$fo->print ( $out."\n");
	}
	$fh->close();
	$fo->close();
}

sub help_text{
        my $this = shift;
        return <<HELP

Usage: ptrbc map [options]

--input_dir	Input raw or dictionary data file directory
--dic		The dictionary file
--raw		The raw data file
--output_dir	Output mapped file directory( Stored in the input directory by default)	

--help		Show this message

HELP

}

1; # End of Mapping
