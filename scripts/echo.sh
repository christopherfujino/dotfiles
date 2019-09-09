#!/bin/bash

echo "2019-08-14 09:43:23.309 altool[70776:801504] No errors uploading 'dart2js.dart.snapshot.zip'.\nRequestUUID = 3dc7f192-bd4c-4b35-92de-82fd4fc36903" | sed -n 's/.*RequestUUID = \([a-z0-9-]*\).*/\1/p'
