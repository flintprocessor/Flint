#!/bin/sh
git config --local user.name "jasonnam"
git config --local user.email "contact@jasonnam.com"
version=`cat Version`
git tag $version
