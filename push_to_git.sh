#!/bin/bash
cd /Shared/Statepi_Diagnosis/skoeneman/delay_dx/analysis_scripts/sepsis_alg2
module load R
R CMD BATCH main_script.R
