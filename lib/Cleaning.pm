package Cleaning;

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
	$this->{'mapped'} = undef;
	$this->{'rules'} = undef;
	$this->{'output_dir'} = undef;
	bless $this, $class;
	$this->process();
	return $this;
}


sub process {
	my $this = shift;
	my ( $help, $options );
	unless ( @ARGV ) { die $this->help_text(); }
	$options = GetOptions(
		'input_dir=s' => \$this->{'input_dir'},
		'mapped=s' => \$this->{'mapped'},
		'rules=s' => \$this->{'rules'},
		'output_dir=s' => \$this->{'output_dir'},
		'help' => \$help,
	);
	if( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
	unless ( $this->{'mapped'}) { warn 'You must provide a mapped data file ! ', "\n"; die help_text(); }
	unless ( $this->{'rules'} ) { warn 'You must provide a cleaning rules file ! ', "\n"; die help_text(); }
	# unless ( -d $this->{'output_dir'} ) { $this->{'output_dir'} = $this->{'input_dir'}; }
	my $fh = new FileHandle; # To open the rules and mapped data 
	my $fc = new FileHandle; # To open the output cleaned data
	my $fs = new FileHandle; # To open the output suspect data
	die "Could not open the cleaning rules !\n" unless ( $fh->open("<$this->{'input_dir'}/$this->{'rules'}") );
	my %rul;
	while( my $ll = $fh->getline ){
		chomp( $ll );
		unless ( $ll =~ /^#|property/ ){
			my @line = split (/\t/, $ll, -1);
                        $rul{$line[0]} = $ll;
#			print STDERR $line[0]."->\t".$rul{$line[0]}."\n";
		}
	}
	#foreach my $kk(sort keys %rul){ print STDERR $kk.":".$rul{$kk}."\n";}
	$fh->close();
	die "Could not open the mapped data file !\n" unless ( $fh->open("<$this->{'input_dir'}/$this->{'mapped'}") );
	my $temp=$this->{'mapped'};
        $temp=~s/\.xlsx//g;
	die "Could not open the cleaned output file !\n" unless ( $fc->open(">$this->{'output_dir'}/${temp}_cleaned.xlsx") );
	die "Could not open the suspect output file !\n" unless ( $fs->open(">$this->{'output_dir'}/${temp}_suspect.xlsx") );
	my $first_line = $fh->getline;
	chomp ( $first_line );
	$fc->print( $first_line."\n" );
	$fs->print( "FLAG\t".$first_line."\n" );
	my @properties = split (/\t/, $first_line, -1);
	my %pro_index;
	my $idx = 0;
	map{ $pro_index{$idx} = $_; $idx++; } @properties; 
	my $out_flag;
	my $oo_info="";
	#for(my $i=0; $i<72; $i++){ my $pro_name = $pro_index{$i}; print $i.":".$rul{$pro_name}."\n";}
	while( my $out = $fh->getline ){ 
		chomp( $out );
		my @line = split ( /\t/, $out, -1 ); # reserved the end null field
		my $count = 0;
		$out_flag = 0;
		#print STDERR $out."\n";##
		#foreach(@line){ print $_."\n";}
		#my $tmp=@line; print "######$tmp\n";
		LINE:foreach my $ee ( @line ){
			my $pro_name = $pro_index{$count};
			my ( $tt, $pro_type, $pro_range ) = ( "non", "non", "non" );
			($tt, $pro_type, $pro_range )= split (/\t/, $rul{$pro_name}, -1);
			my $oo=@line;
			#print STDERR $oo.":".$ee.">>>>>".$pro_type."\n";
			#print STDERR $count.">>>>>".$pro_type."\n";
			if( $pro_type =~ /string/ ){
				unless( $ee =~/\w+/ ) { # the property is null 
					$out_flag = 1;
					my $tmp = $count+1;
					$oo_info = "$tmp $pro_name ( $ee ): ";
					last LINE if( $out_flag );
				}  
			}
			elsif( $pro_type =~ /enum/){
				my @ems = split (/,/, $pro_range, -1);
				my $ele = $ee;
				if( !$ele ){ # the property is null
					$out_flag = 2;
					my $tmp = $count+1;
					$oo_info = "$tmp $pro_name ( $ee ): ";
					last LINE if( $out_flag );
				}else{
					my $non_match = 1;
					foreach( @ems ){ # check the non-null property is in the enum values range
						if( $ele =~ /$ee/ ){
							$non_match = 0;
						}
					}
					if( $non_match ){
						$out_flag = 3;
						my $tmp = $count+1;
						$oo_info = "$tmp $pro_name ( $ee ): ";			
						last LINE if( $out_flag );
					}
				}
			}
			elsif( $pro_type =~ /lower_bound/ ){
				if( !$ee ){ 
					$out_flag = 4;
					my $tmp = $count+1;
					$oo_info = "$tmp $pro_name ( $ee ): ";		
					last LINE if( $out_flag );
				}else{
					if( $ee <= $pro_range ){
						$out_flag = 5;
						my $tmp = $count+1;
						$oo_info = "$tmp $pro_name ( $ee ): ";			
                                        	last LINE if( $out_flag );
					}
				}
			}
			elsif( $pro_type =~ /range/ ){
				my ( $ld, $ud ) = split ( /-/, $pro_range, -1); # lower bound and upper bound
                               	my $ele = $ee;
                                if( !$ele ){ # the property is null
					$out_flag = 6;
					my $tmp = $count+1;
					$oo_info = "$tmp $pro_name ( $ee, range: $pro_range ): ";		
                                        last LINE if( $out_flag );
                                }else{
					if( ( $ee <= $ld ) || ( $ee >= $ud ) ){
						$out_flag = 7;
						my $tmp = $count+1;
						$oo_info = "$tmp $pro_name ( $ee, range: $pro_range ): ";
						last LINE if( $out_flag );
					}
				}
			}
			$count++;#print STDERR $count.">>>>>"."\n";
		}
	#	print $out_flag."\n";
		if( !$out_flag ){ 
			$fc->print( $out."\n" );
			#print STDERR $out_flag."-----\n";
			#print $out."\n";
		}
		else{
			#$fs->print( "FLAG >> $oo_info\t".$out."\n" );
			$fs->print( "$oo_info\t".$out."\n" );
	#	#	print STDERR $out_flag."\n";
	#		print "kkkkkkkkkkkkkkk".$out."\n";
		}
	} 
	#print STDERR $cc."\n";
	$fh->close();
	$fc->close();
	$fs->close();
}

sub help_text{
	my $this = shift;
	return <<HELP

Usage: ptrbc clean [options]

--input_dir	Input mapped or cleaning-rules data file directory	
--mapped	The mapped file
--rules	The cleaning rules file
--output_dir	Output cleaned or suspect file directory( Stored in the input directory by default) 

--help	Show this message

HELP

}
1; # End of Cleaning
