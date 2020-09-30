# CAFO

To create the `cafo` conda environment, run
`source create_environment.sh`
from the `environments` subdirectory. When finished, activate the environment with the command `conda activate cafo`.

To build the required data assets, execute the scripts contained in `datasets/source_data_scripts` to download the source data; then execute the scripts contained in `datasets/derived_data_scripts` to build the derived data. These scripts document how the source data is obtained and transformed to support the downstream analysis. As the requisite data transformations become known and stable, they migrate from notebooks to scripts to keep the contents of the notebooks focused on analysis. 
