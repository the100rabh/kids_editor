#!/bin/bash
pub run pwa
git add lib/pwa/offline_urls.g.dart
git commit -m "updating pwa file"
git push origin 
peanut
git push origin --set-upstream gh-pages
