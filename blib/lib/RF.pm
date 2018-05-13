package RF;

use 5.006;
use strict;
use warnings;

use Carp;
use Getopt::Long;
use IO::File;
use FileHandle;
our $VERSION = '1.0';

sub new {
	my $class = shift;
	my $this = {};
	$this->{'input_file'} = undef;
	$this->{'pct'} = 0.9;
	$this->{'file_col'} = undef;
	$this->{'rf_type'} = "response";
	$this->{'rf_step_size'} = 10;
	$this->{'rf_max_trees'} = 20;
	$this->{'output_pred'} = "data/RF_pred_result.csv";
	$this->{'output_label'} = "data/RF_label_result.csv";
	bless $this, $class;
	$this->process();
	return $this;
}


sub process {
	my $this = shift;
	my ( $help, $options );
	unless ( @ARGV ) { die $this->help_text(); }
	$options = GetOptions(
		'input_file=s' => \$this->{'input_file'},
		'pct=f' => \$this->{'pct'},
		'file_col=i' => \$this->{'file_col'},
		'rf_type=s' => \$this->{'rf_type'},
		'rf_step_size=i' => \$this->{'rf_step_size'},
		'rf_max_trees=i' => \$this->{'rf_max_trees'},
		'output_pred=s' => \$this->{'output_pred'},
		'output_label=s' => \$this->{'output_label'},
		'help' => \$help,
	);
	if( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
	unless ( $this->{'input_file'}) { warn 'You must provide an input train data file ! ', "\n"; die help_text(); }
	#unless ( $this->{'input_test_file'} ) { warn 'You must provide an input test file ! ', "\n"; die help_text(); }
	unless ( $this->{'output_pred'} ){ $this->{'output_pred'}="data/RF_pred_result.csv"; }
	unless ( $this->{'output_label'} ){ $this->{'output_label'}="data/RF_label_result.csv"; }
	system("Rscript mllib/method_rf.R $this->{'input_file'} $this->{'pct'} $this->{'file_col'} $this->{'rf_type'} $this->{'rf_step_size'}  $this->{'rf_max_trees'} $this->{'output_pred'} $this->{'output_label'}");	
}

sub help_text{
	my $this = shift;
	return <<HELP

Usage: ptrbc rf [options]

--input_file	        Input the training data file with the whole dircctory
--pct	                The percent of the training data in the input data,
			default=0.9
--file_col	        File_col
--rf_type	        Predict type, default=response
--rf_step_size          RF step size, default=10
--rf_max_trees          The maximum of building trees, default=20
--output_pred           Output the RF predicted results, 
			default=data/RF_pred_result.csv
--output_label          Output the RF predicted results, 
			default=data/RF_label_result.csv
--help	                Show this message

HELP

}
1; # End of RF
