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
	$this->{'input_file'} = undef;
	$this->{'pct'} = 0.9;
	$this->{'bp_size'} = 12;
	$this->{'bp_matrix_size'} = 100;
	$this->{'bp_decay'} = 0.01;
	$this->{'bp_range'} = 0.1;
	$this->{'file_col'} = undef;
	$this->{'bp_type'} = "class";
	$this->{'output_pred'} = "data/BP_pred_result.out";
	$this->{'output_label'} = "data/BP_label_result.out";
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
		'bp_size=i' => \$this->{'bp_size'},
		'bp_matrix_size=i' => \$this->{'bp_matrix_size'},
		'bp_decay=f' => \$this->{'bp_decay'},
		'bp_range=f' => \$this->{'bp_range'},
		'file_col=i' => \$this->{'file_col'},
		'bp_type=s' => \$this->{'bp_type'},
		'output_pred=s' => \$this->{'output_pred'},
		'output_label=s' => \$this->{'output_label'},
		'help' => \$help,
	);
	if( $help ) { print STDERR help_text(); exit 0; }
	unless ( $options ) { die $this->help_text(); }
	unless ( $this->{'input_file'}) { warn 'You must provide an input train data file ! ', "\n"; die help_text(); }
	#unless ( $this->{'input_test_file'} ) { warn 'You must provide an input test file ! ', "\n"; die help_text(); }
	unless ( $this->{'output_pred'} ){ $this->{'output_pred'}="data/bp_pred_output.xlsx"; }
	unless ( $this->{'output_label'} ){ $this->{'output_label'}="data/bp_label_output.xlsx"; }
	system("Rscript mllib/method_bp.R $this->{'input_file'}  $this->{'pct'}  $this->{'bp_size'} $this->{'bp_matrix_size'}  $this->{'bp_decay'} $this->{'bp_range'} $this->{'file_col'} $this->{'bp_type'} $this->{'output_pred'} $this->{'output_label'}");	
}

sub help_text{
	my $this = shift;
	return <<HELP

Usage: ptrbc bp [options]

--input_file	        Input the training data file with the whole dircctory
--pct	                The percent of the training data in the input data, default=0.9
--bp_size	        Bp_size, default=12
--bp_matrix_size	Bp_matrix_size, default=100
--bp_decay              Bp_decay, default=5e-6
--bp_range              Bp_range, default=0.1
--file_col              File_col
--bp_type               Bp_type: include class or predict, default=class
--output_pred           Output the bp predicted results, default=data/bp_pred_output.xlsx
--output_label          Output the bp predicted results, default=data/bp_label_output.xlsx
--help	                Show this message

HELP

}
1; # End of BP
