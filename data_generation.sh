#! /bin/bash

# changing to right directory
cd YOUR_PATH/src
ls

#run python scripts
conda run -n dbms python customer_details.py 1000
conda run -n dbms python card_details.py 1500
conda run -n dbms python netbank_details.py 1000
conda run -n dbms python terminal_details.py 100
conda run -n dbms python transaction_simulator.py 1500 100

#go to parent 
cd ..
cd notebooks
papermill mappings.ipynb mappings_output.ipynb -p n_cust 1000 -p n_card 1500 

#I think this is about it
echo "All done"

