package SVM;

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
	$this->{'svm_type'} = "class";
	$this->{'output_pred'} = "data/SVM_pred_result.csv";
	$this->{'output_label'} = "data/SVM_label_result.csv";
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
		'svm_type=s' => \$this->{'svm_type'},
		'output_pred=s' => \$this->{'output_pred'},
		'output_label=s' => \$this->{'output_label'},
		'help' => \$help,
	);
	if( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
	unless ( $this->{'input_file'}) { warn 'You must provide an input train data file ! ', "\n"; die help_text(); }
	#unless ( $this->{'input_test_file'} ) { warn 'You must provide an input test file ! ', "\n"; die help_text(); }
	unless ( $this->{'output_pred'} ){ $this->{'output_pred'}="data/SVM_pred_result.csv"; }
	unless ( $this->{'output_label'} ){ $this->{'output_label'}="data/SVM_label_result.csv"; }
	system("Rscript mllib/method_svm.R $this->{'input_file'} $this->{'pct'} $this->{'svm_type'} $this->{'output_pred'} $this->{'output_label'}");	
}

sub help_text{
	my $this = shift;
	return <<HELP

Usage: ptrbc svm [options]

--input_file	        Input the training data file with the whole dircctory
--pct	                The percent of the training data in the input data,
			default=0.9
--svm_type	        Predict type, default=response
--output_pred           Output the SVM predicted results, 
			default=data/SVM_pred_result.csv
--output_label          Output the SVM predicted results, 
			default=data/SVM_label_result.csv
--help	                Show this message

HELP

}
1; # End of SVM
