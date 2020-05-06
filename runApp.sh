#!/bin/bash
docker run --rm --name cbenabler-server -d -h cbenabler-server -p 3000:3000 cbenablereveris/cb-data-visualisation-enabler-server:dev
docker run --rm --name cbenabler --link cbenabler-server -d -h cbenabler -p 80:80 cbenablereveris/cb-data-visualisation-enabler:dev
