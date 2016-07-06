#!/bin/bash

java -jar $(pwd)/embed_tools/signapk/signapk.jar $(pwd)/embed_tools/signapk/certificate.pem $(pwd)/embed_tools/signapk/key.pk8 "$@"