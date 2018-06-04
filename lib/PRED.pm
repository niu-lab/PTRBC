package PRED;

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
	$this->{'model'} = undef;
	$this->{'input_file'} = undef;
	$this->{'output_pred'} = "data/rf_predict_output.csv";
	bless $this, $class;
	$this->process();
	return $this;
}


sub process {
	my $this = shift;
	my ( $help, $options );
	unless ( @ARGV ) { die $this->help_text(); }
	$options = GetOptions(
		'model=s' => \$this->{'model'},
		'input_file=s' => \$this->{'input_file'},
		'output_pred=s' => \$this->{'output_pred'},
		'help' => \$help,
	);
	if( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
	unless ( $this->{'input_file'}) { warn 'You must provide an input train data file ! ', "\n"; die help_text(); }
	#unless ( $this->{'input_test_file'} ) { warn 'You must provide an input test file ! ', "\n"; die help_text(); }
	unless ( $this->{'output_pred'} ){ $this->{'output_pred'}="data/rf_predict_output.csv"; }
	if($this->{'model'} eq 'rf'){
		system("Rscript mllib/pred_rf_model.R $this->{'input_file'} $this->{'output_pred'}");
	}
}

sub help_text{
	my $this = shift;
	return <<HELP

Usage: ptrbc pred [options]

--model                 Select model to predict, default model is rf, and optional models are: rf, svm, xgboost, bp and knn
--input_file	        Input the testing data file with the whole dircctory
--output_pred           Output the RF predicted results, 
			default=data/rf_predict_output.csv
--help	                Show this message

HELP

}
1; # End of PRED
