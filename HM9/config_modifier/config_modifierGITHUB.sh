#!/usr/bin/bash

payroll_file=$1

###########################################################
# Phase 1
###########################################################

awk_code = '' # awk command here
field_seperator_1='' # What should the feel seperator be?
awk -F "$field_seperator" "$awk_code" "$payroll_file" > w2_info

###########################################################
# Phase 2
###########################################################

field_seperator_2='' # What should this field seperator be?
awk -F "$field_seperator" -f data_aggregator.awk < w2_info > agg_data
