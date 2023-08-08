#!/bin/bash
gcloud auth activate-service-account cloudrun-call-gcs-api@dmz-jitsi.iam.gserviceaccount.com --key-file=key.json
python3 file_api.py