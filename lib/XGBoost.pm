package XGBoost;

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
	$this->{'input_file'} = undef;
	$this->{'pct'} = 0.9;
	$this->{'file_col'} = undef;
	$this->{'total_category'} = 20;
	$this->{'xgboost_nthread'} = 2;
	$this->{'xgboost_nrounds'} = 100;
	$this->{'xgboost_subsample'} = 0.5;
	$this->{'xgboost_objective'} = "multi:softmax";
	$this->{'output_pred'} = "data/xgboost_pred_result.csv";
	$this->{'output_label_numeric'} = "data/xgboost_label_numeric_result.csv";
	$this->{'output_label'} = "data/xgboost_label_result.csv";
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
		'total_category=i' => \$this->{'total_category'},
		'xgboost_nthread=i' => \$this->{'xgboost_nthread'},
		'xgboost_nrounds=i' => \$this->{'xgboost_nrounds'},
		'xgboost_subsample=f' => \$this->{'xgboost_subsample'},
		'xgboost_objective=s' => \$this->{'xgboost_objective'},
		'output_pred=s' => \$this->{'output_pred'},
		'output_label_numeric=s' => \$this->{'output_label_numeric'},
		'output_label=s' => \$this->{'output_label'},
		'help' => \$help,
	);
	if( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
	unless ( $this->{'input_file'}) { warn 'You must provide an input train data file ! ', "\n"; die help_text(); }
	#unless ( $this->{'input_test_file'} ) { warn 'You must provide an input test file ! ', "\n"; die help_text(); }
	unless ( $this->{'output_pred'} ){ $this->{'output_pred'}="data/xgboost_pred_result.csv"; }
	unless ( $this->{'output_label_numeric'} ){ $this->{'output_label_numeric'}="data/xgboost_label_numeric_result.csv"; }
	unless ( $this->{'output_label'} ){ $this->{'output_label'}="data/xgboost_label_result.csv
"; }
	system("Rscript mllib/method_xgboost.R $this->{'input_file'} $this->{'pct'} $this->{'file_col'} $this->{'total_category'} $this->{'xgboost_nthread'}  $this->{'xgboost_nrounds'} $this->{'xgboost_subsample'} $this->{'xgboost_objective'} $this->{'output_pred'} $this->{'output_label_numeric'} $this->{'output_label'}");	
}

sub help_text{
	my $this = shift;
	return <<HELP

Usage: ptrbc xgboost [options]

--input_file	        Input the training data file with the whole dircctory
--pct	                The percent of the training data in the input data,
			default=0.9
--file_col	        File_col
--total_category	Total_category, default=20
--xgboost_nthread       XGBboost_nthread, default=2
--xgboost_nrounds       XGBboost_nrounds, default=100
--xgboost_subsample     XGBboost_subsample, default=0.5
--xgboost_objective     XGBboost_objective: include class or predict, 
			default=multi:softmax
--output_pred           Output the XGBboost predicted results, 
			default=data/xgboost_pred_result.csv
--output_label_numeric  Output the XGBboost numeric label, 
			default=data/xgboost_label_numeric_result.csv
--output_label          Output the XGBboost predicted results, 
			default=data/xgboost_label_result.csv
--help	                Show this message

HELP

}
1; # End of BP
