PTRBC
===============

This clinical data analysis tool can be used to do data cleaning and predict the required transfusion volume of red blood cells in surgical patients based on machine learning.

Usage
-----

        Program:     PTRBC - Prediction of Transfusion with Red Blood Cells
	
        Version:     v1.0

        Authors:     Beifang Niu, Ruilin Li, et al.

  Usage: ptrbc <command> [options]

	Key commands:
	
		map          -- Transform the raw data to identifiable format
		clean        -- Data cleaning and got clean data
		bp           -- Run Back Propagation(BP) method
		rf	     -- Run Random Forest(RF) method
		xgboost      -- Run XGBoost method
		svm          -- Run Support Vector Machines(SVM) method
		knn          -- Run k-NearestNeighbor(KNN) method
		pred         -- Predict the required volume according to models
		help         -- Show this message

      
Examples
--------

1. ptrbc map [options]

Usage: ptrbc map [options]

--input_dir     Input raw or dictionary data file directory
--dic           The dictionary file
--raw           The raw data file
--output_dir    Output mapped file directory( Stored in the input directory by default)

--help          Show this message

```
ptrbc map --input_dir ./data/ --dic mapping_dictionary --raw revise_all_raw.xlsx --output_dir ./data
```
2. ptrbc clean [options]

Usage: ptrbc clean [options]

--input_dir     Input mapped or cleaning-rules data file directory
--mapped        The mapped file
--rules The cleaning rules file
--output_dir    Output cleaned or suspect file directory( Stored in the input directory by default)

--help  Show this message

```
ptrbc clean --input_dir data/ --mapped revise_all_raw.xlsx_mapped --rules cleaning_rules --output_dir ./data
```
3. ptrbc bp [options] 

Usage: ptrbc bp [options]

--input_file            Input the training data file with the whole dircctory
--pct                   The percent of the training data in the input data, default=0.9
--bp_size               Bp_size, default=12
--bp_matrix_size        Bp_matrix_size, default=100
--bp_decay              Bp_decay, default=0.01
--bp_range              Bp_range, default=0.1
--file_col              File_col
--bp_type               Bp_type: include class or predict, default=class
--output_pred           Output the bp predicted results, default=data/bp_pred_output.xlsx
--output_label          Output the bp predicted results, default=data/bp_label_output.xlsx
--help                  Show this message

```
ptrbc bp --input_train_file data/method_bp_sample.data --input_test_file data/method_bp_sample.data --bp_size 12 --bp_matrix_size 10 --bp_decay 5e-6  --bp_range 0.1 --file_col 40 --bp_type class --output_file data/BP_pred_result.out
```
4. ptrbc rf [options]

Usage: ptrbc rf [options]

--input_file            Input the training data file with the whole dircctory
--pct                   The percent of the training data in the input data,
                        default=0.9
--file_col              File_col
--rf_type               Predict type, default=response
--rf_step_size          RF step size, default=10
--rf_max_trees          The maximum of building trees, default=20
--output_pred           Output the RF predicted results,
                        default=data/RF_pred_result.csv
--output_label          Output the RF predicted results,
                        default=data/RF_label_result.csv
--help                  Show this message

```
ptrbc rf --input_file data/method_rf_sample.data --pct 0.9 --file_col 40 --rf_type response --rf_step_size 10 --rf_max_trees 20 --output_pred data/RF_pred_result.csv --output_label data/RF_label_result.csv
```
5. ptrbc xgboost [options]
Usage: ptrbc xgboost [options]

--input_file            Input the training data file with the whole dircctory
--pct                   The percent of the training data in the input data,
                        default=0.9
--file_col              File_col
--total_category        Total_category, default=20
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
--help                  Show this message

```
ptrbc xgboost --input_file data/method_xgboost_sample.data --pct 0.9 --file_col 40 --total_category 20 --xgboost_nthread 2 --xgboost_nrounds 100 --xgboost_subsample 0.5 --xgboost_objective multi:softmax --output_pred data/xgboost_pred_result.csv --output_label_numeric data/xgboost_label_numeric_result.csv --output_label data/xgboost_label_result.csv
``` 
6. ptrbc svm [options]

Usage: ptrbc svm [options]

--input_file            Input the training data file with the whole dircctory
--pct                   The percent of the training data in the input data,
                        default=0.9
--svm_type              Predict type, default=response
--output_pred           Output the SVM predicted results,
                        default=data/SVM_pred_result.csv
--output_label          Output the SVM predicted results,
                        default=data/SVM_label_result.csv
--help                  Show this message

```
ptrbc svm --input_file data/method_svm_sample.data --pct 0.9 --svm_type class --output_pred data/SVM_pred_result.csv --output_label data/SVM_pred_result.csv
```
7. ptrbc knn [options]
Usage: ptrbc knn [options]

--input_file            Input the training data file with the whole dircctory
--pct                   The percent of the training data in the input data,
                        default=0.9
--file_col              File_col
--knn_K                 The number of neighbours, default=10
--output_pred           Output the KNN predicted results,
                        default=data/KNN_pred_result.csv
--output_label          Output the KNN predicted results,
                        default=data/KNN_label_result.csv
--help                  Show this message

```
ptrbc knn --input_file data/method_knn_sample.data --pct 0.9 --file_col 40 --knn_K 10 --output_pred data/KNN_pred_result.csv --output_label data/KNN_label_result.csv
```

Support
-------

For user support please email lirl@sccas.cn

Update
------

To reinstall code of the same version (in some cases, may need --sudo):

	cpanm --reinstall ptrbc-1.0.tar.gz


Install (In Linux system)
-------

The README is used to introduce the module and provide instructions on
how to install the module, any machine dependencies it may have (for
example C compilers and installed libraries) and any other information
that should be provided before the module is installed.

A README file is required for CPAN modules since CPAN extracts the README
file from a module distribution so that people browsing the archive
can use it to get an idea of the module's uses. It is usually a good idea
to provide version information here so that people can decide whether
fixes for the module are worth downloading.


INSTALLATION

    R Modules required
    1. BP module
       DMwR and dependencies: xts, quantmod, TTR, curl, abind, ROCR, gplots, gtools, gdata, caTools, bitops
    2. RF module
       randomForest
    3. XGBoost module
       xgboost  
    4. SVM module
       e1071
    5. KNN module
       gmodels, class

To install this module, run the following commands:

	perl Makefile.PL
	make
	make test
	make install

SUPPORT AND DOCUMENTATION

After installing, you can find documentation for this module with the
perldoc command.

    perldoc ptrbc

You can also look for information at:

    RT, CPAN's request tracker (report bugs here)
        http://rt.cpan.org/NoAuth/Bugs.html?Dist=ptrbc

    AnnoCPAN, Annotated CPAN documentation
        http://annocpan.org/dist/ptrbc

    CPAN Ratings
        http://cpanratings.perl.org/d/ptrbc

    Search CPAN
        http://search.cpan.org/dist/ptrbc/


LICENSE AND COPYRIGHT

Copyright (C) 2017 Ruilin Li

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

