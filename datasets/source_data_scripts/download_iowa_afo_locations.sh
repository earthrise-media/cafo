# This shapefile contains locations of animal feeding operations that are registered,
# permitted or monitored by the Iowa DNR.
# https://open-iowa.opendata.arcgis.com/datasets/iowadnr::animal-feeding-operations
mkdir ../source_data/iowa_afo_locations
curl https://opendata.arcgis.com/datasets/b51d57dbc8304be185cf1206ff992da1_2.zip?outSR=%7B%22latestWkid%22%3A26915%2C%22wkid%22%3A26915%7D > ../source_data/iowa_afo_locations/locations.zip
cd ../source_data/iowa_afo_locations
unzip locations.zip
rm locations.zip

