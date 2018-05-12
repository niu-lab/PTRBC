package BP;

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
	$this->{'input_train_file'} = undef;
	$this->{'input_test_file'} = undef;
	$this->{'bp_size'} = undef;
	$this->{'bp_matrix_size'} = undef;
	$this->{'bp_decay'} = undef;
	$this->{'bp_range'} = undef;
	$this->{'file_col'} = undef;
	$this->{'bp_type'} = undef;
	$this->{'output_file'} = undef;
	bless $this, $class;
	$this->process();
	return $this;
}


sub process {
	my $this = shift;
	my ( $help, $options );
	unless ( @ARGV ) { die $this->help_text(); }
	$options = GetOptions(
		'input_train_file=s' => \$this->{'input_train_file'},
		'input_test_file=s' => \$this->{'input_test_file'},
		'bp_size=i' => \$this->{'bp_size'},
		'bp_matrix_size=i' => \$this->{'bp_matrix_size'},
		'bp_decay=f' => \$this->{'bp_decay'},
		'bp_range=f' => \$this->{'bp_range'},
		'file_col=i' => \$this->{'file_col'},
		'bp_type=s' => \$this->{'bp_type'},
		'output_file=s' => \$this->{'output_file'},
		'help' => \$help,
	);
	if( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
	unless ( $this->{'input_train_file'}) { warn 'You must provide an input train data file ! ', "\n"; die help_text(); }
	unless ( $this->{'input_test_file'} ) { warn 'You must provide an input test file ! ', "\n"; die help_text(); }
	unless ( $this->{'output_file'} ){ $this->{'output_file'}="bp_predict_output.xlsx"; }
	system("Rscript mllib/method_bp.R $this->{'input_train_file'}  $this->{'input_test_file'}  $this->{'bp_size'} $this->{'bp_matrix_size'}  $this->{'bp_decay'} $this->{'bp_range'} $this->{'file_col'} $this->{'bp_type'} $this->{'output_file'}");	
}

sub help_text{
	my $this = shift;
	return <<HELP

Usage: ptrbc bp [options]

--input_train_file	Input the training data file with the whole dircctory
--input_test_file	Input the testing data file with the whole dircctory
--bp_size	        bp_size
--bp_matrix_size	bp_matrix_size 
--bp_decay              bp_decay
--bp_range              bp_range
--file_col              file_col
--bp_type               bp_type: include class or predict
--output_file           Output the bp predicted results
--help	                Show this message

HELP

}
1; # End of BP
