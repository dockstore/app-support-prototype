#!/bin/bash
for filename in xena/files/*.tsv; do
    docker exec xena java -jar /ucsc_xena/cavm-0.24.0-standalone.jar --load /root/xena/files/$filename
done
