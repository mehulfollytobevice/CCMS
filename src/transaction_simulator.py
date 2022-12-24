#  this file contains the code for generating the transaction data
#  the transaction table contains the following columns:
#  1. card_num
#  2. txn_id
#  3. txn_date
#  4. txn_time
#  5. txn_val_usd
#  5. terminal_id

import random
import numpy as np
import pandas as pd

# PATH where data must be stored:
PATH='YOUR PATH/data'


def get_list_terminals_within_radius(card_profile, x_y_terminals, r):
    
    # Use numpy arrays in the following to speed up computations
    
    # Location (x,y) of customer as numpy array
    x_y_customer = card_profile[['x-coordinate','y-coordinate']].values.astype(float)
    
    # Squared difference in coordinates between customer and terminal locations
    squared_diff_x_y = np.square(x_y_customer - x_y_terminals)
    
    # Sum along rows and compute suared root to get distance
    dist_x_y = np.sqrt(np.sum(squared_diff_x_y, axis=1))
    
    # Get the indices of terminals which are at a distance less than r
    available_terminals = list(np.where(dist_x_y<r)[0])
    
    # Return the list of terminal IDs
    return available_terminals

    
def generate_transactions_table(card_profile,index, start_date = "2022-06-01", nb_days = 100):
    
    card_transactions = []
    
    random.seed(int(index))
    np.random.seed(int(index))
    
    # For all days
    for day in range(nb_days):
        
        # Random number of transactions for that day 
        nb_tx = np.random.poisson(card_profile.mean_nb_tx_per_day)
        
        # If nb_tx positive, let us generate transactions
        if nb_tx>0:
            
            for tx in range(nb_tx):
                
                # Time of transaction: Around noon, std 20000 seconds. This choice aims at simulating the fact that 
                # most transactions occur during the day.
                time_tx = int(np.random.normal(86400/2, 20000))
                
                # If transaction time between 0 and 86400, let us keep it, otherwise, let us discard it
                if (time_tx>0) and (time_tx<86400):
                    
                    # Amount is drawn from a normal distribution  
                    amount = np.random.normal(card_profile.mean_amount, card_profile.std_amount)
                    
                    # If amount negative, draw from a uniform distribution
                    if amount<0:
                        amount = np.random.uniform(0,card_profile.mean_amount*2)
                    
                    amount=np.round(amount,decimals=2)
                    
                    if len(card_profile.available_terminals)>0:
                        
                        terminal_id = random.choice(card_profile.available_terminals) +1
                    
                        card_transactions.append([time_tx+day*86400, day,
                                                      card_profile.card_number, 
                                                      terminal_id, amount])
            
    card_transactions = pd.DataFrame(card_transactions, columns=['TX_TIME_SECONDS', 'TX_TIME_DAYS', 'CARD_ID', 'TERMINAL_ID', 'TX_AMOUNT'])
    
    if len(card_transactions)>0:
        card_transactions['TX_DATETIME'] = pd.to_datetime(card_transactions["TX_TIME_SECONDS"], unit='s', origin=start_date)
        card_transactions['TXN_ID']= card_transactions['TX_DATETIME']\
            .apply(lambda x: ''.join(filter(str.isalnum,str(x))))+\
                card_transactions['CARD_ID'].astype(str)+\
                    card_transactions['TERMINAL_ID'].astype(str).str.zfill(3)
        card_transactions=card_transactions[['TXN_ID','TX_DATETIME','CARD_ID', 'TERMINAL_ID', 'TX_AMOUNT','TX_TIME_SECONDS', 'TX_TIME_DAYS']]
    
    return card_transactions
    

if __name__=="__main__":
    
    # for how many cards do we want to generate transactions
    from sys import argv
    n_cards=int(argv[1])
    n_terms=int(argv[2])

    #import card data and terminal data
    card_profiles_table=pd.read_csv(PATH+f'/table_card_n-{n_cards}.csv')
    terminal_profiles_table=pd.read_csv(PATH+f'/table_terminals_n-{n_terms}.csv')
    x_y_terminals = terminal_profiles_table[['x_terminal_id','y_terminal_id']].values.astype(float)

    #modify card table
    card_profiles_table['available_terminals']=card_profiles_table.\
        apply(lambda x : 
        get_list_terminals_within_radius(x, x_y_terminals=x_y_terminals, r=50), axis=1)

    transact_df=[]
    for index,card_profile in card_profiles_table.head(n_cards).iterrows():
        t_df=generate_transactions_table(card_profile,index)
        transact_df.append(t_df)
        print(f'Generating transaction for card-{index}')
    
    transactions=pd.concat(transact_df, ignore_index=True)
    transactions.to_csv(f'{PATH}/table_transactions_n-{n_cards}.csv')