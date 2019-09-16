#!/bin/bash

HOME=$(mktemp -d --suffix=.matlab)
INPUT_DIR='./execute/input'
anat=$INPUT_DIR/anat_CURE1011_SC1_t1_struct.ni

MANIFEST=./execute/specs/manifest.json

# Initialize config parameters
realignment=' '
deformatione=' '
smoothing=' '


# Generate flags from the manifest
realignment_flag=$(jq -r <$MANIFEST '''.config.realignment.id')
deformation_flag=$(jq -r <$MANIFEST '''.config.deformation.id')
smoothing_flag=$(jq -r <$MANIFEST '''.config.smoothing.id')

#execute the command
exec /opt/spm12/spm12 script /opt/spm12/spm_preproc_pipeline.m $INPUT_DIR $anat $realignment_flag $deformation_flag $smoothing_flag