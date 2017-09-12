#!/bin/bash

unset PYTHONHOME
unset PYTHONPATH

echo "
from azure.storage.blob import BlockBlobService
import numpy as np

accessKey = 'f9T0B+jshYHi3UkfiuXsMOaQr9u9/YHHdwOGZg+MHhcLU8E3ANlJvGzf5ssxK//iWaOynMc7EPK151evwO9B5g=='
containerName = 'gaia-data'
accountName = 'gaiadiag597'

def download(segment):
    block_blob_service = BlockBlobService(account_name=accountName, account_key=accessKey)

    generator = block_blob_service.list_blobs(containerName)
    blobs = [blob.name for blob in generator if blob.name.upper() not in ['MD5SUM', 'CITATION', 'DISCLAIMER']]
    groups = np.array_split(blobs, 16)

    for blobset in groups[segment]:
        block_blob_service.get_blob_to_path(containerName, blobset, '/dev/stdout', max_connections=1)

download(${GP_SEGMENT_ID})" | /home/gpadmin/anaconda3/bin/python -u | egrep -v "solution_id\,source_id"