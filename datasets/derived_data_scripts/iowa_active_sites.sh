#! /usr/bin/env python
import numpy as np
import geopandas as gpd

# Read in the Iowa animal feeding operations dataset
afo_df = gpd.read_file('../source_data/iowa_afo_locations/Animal_Feeding_Operations.shp')

# Reduce the data to the active facilities
active_afo_df = afo_df[afo_df['opStatus'] == 'Active']

# Select the facilities in Iowa
active_afo_df = active_afo_df[active_afo_df['State'] == 'IA']

# Select the facilities with colMthTxt = 'INTERPOLATION-PHOTO'
active_afo_df = active_afo_df[active_afo_df['colMthTxt'] == 'INTERPOLATION-PHOTO']

# Select the facilities with accuracy of 20.0
active_afo_df = active_afo_df[active_afo_df['Accuracy'] == 20.0]

# Select the facilities with a valid ColDate
active_afo_df = active_afo_df[active_afo_df['ColDate'].notnull()]

# Replace the animal counts that are zero with NaN
count_cols = ['Swine','CattleDair','CattleBeef','Chickens','Turkeys','Horses','SheepLGoat']
active_afo_df[count_cols] = active_afo_df[count_cols].replace(0.0,np.NaN)

# Rename the animal count columns prior to creating flags for types of animal processing
mapping = {
    'CattleDair':'CattleDairy',
    'SheepLGoat':'SheepLGoats'
}
active_afo_df.rename(columns=mapping,inplace=True)

# Create flags for types of animal processing
active_afo_df['Swine Present'] = active_afo_df['Swine'].notna()
active_afo_df['DairyCattle Present'] = active_afo_df['CattleDairy'].notna()
active_afo_df['BeefCattle Present'] = active_afo_df['CattleBeef'].notna()
active_afo_df['Chickens Present'] = active_afo_df['Chickens'].notna()
active_afo_df['Turkeys Present'] = active_afo_df['Turkeys'].notna()
active_afo_df['Horses Present'] = active_afo_df['Horses'].notna()
active_afo_df['Sheep/Goats Present'] = active_afo_df['SheepLGoats'].notna()

flag_cols = ['Swine Present', 'DairyCattle Present', 'BeefCattle Present', 'Chickens Present',
             'Turkeys Present', 'Horses Present', 'Sheep/Goats Present']
active_afo_df['Animals Present'] = active_afo_df[flag_cols].apply(lambda r: ', '.join([k.split(' ')[0] for (k,v) in r.iteritems() if v]), axis=1)
active_afo_df['Animals Present'] = active_afo_df['Animals Present'].replace('','None Specified')

# Recode the point geometry based on latitude and longitude
active_afo_df['geometry'] = gpd.points_from_xy(active_afo_df['Longitude'],active_afo_df['Latitude'])

# Reduce the dataframe down to a subset of key columms
selected_cols = ['facName', 'LocAddress', 'CityName', 'State', 'locZip', 'OperatType',
                 'Swine', 'CattleDairy', 'CattleBeef', 'Chickens', 'Turkeys', 'Horses', 'SheepLGoats',
                 'Swine Present', 'DairyCattle Present', 'BeefCattle Present', 'Chickens Present',
                 'Turkeys Present', 'Horses Present', 'Sheep/Goats Present', 'Animals Present',
                 'colMthTxt', 'refPntTxt', 'ColDate', 'geometry']
active_afo_df = active_afo_df[selected_cols]

# Save the geojson file
active_afo_df.to_file('../derived_data/iowa_active_sites.geojson', driver='GeoJSON')
