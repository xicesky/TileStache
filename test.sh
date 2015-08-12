#!/bin/sh

set -e

# Global packages
if false ; then
    sudo apt-get install -qq \
        gdal-bin memcached \
        python-nose python-imaging python-memcache python-gdal \
        python-coverage python-werkzeug python-psycopg2
fi

# PostgreSQL db
sudo -u postgres psql -c "drop database if exists test_tilestache"
sudo -u postgres psql -c "create database test_tilestache"
sudo -u postgres psql -c "create extension postgis" -d test_tilestache
sudo -u postgres ogr2ogr -nlt MULTIPOLYGON \
    -f "PostgreSQL" PG:"user=postgres dbname=test_tilestache" \
    ./examples/sample_data/world_merc.shp

rm -rf venv
virtualenv -p /usr/bin/python2.7 --system-site-packages venv
. venv/bin/activate
pip install -r requirements.txt --allow-external ModestMaps --allow-unverified ModestMaps
venv/bin/python /usr/bin/nosetests -v --with-coverage --cover-package TileStache

