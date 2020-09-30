conda update -y conda
conda create -y -n cafo anaconda==2020.07
conda activate cafo

pip install gdal==3.0.2 geopandas==0.8.1 rasterio==1.1.0
pip install streamlit pydeck plotly
