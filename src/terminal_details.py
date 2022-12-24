# this file contains the code for generating the terminal data
# the terminals details contains:
#  1. terminal ID
#  2. geographical location (x_terminal_id, y_terminal_id)

#  import libraries
import numpy as np
import pandas as pd

# where should the data be saved 
PATH='YOUR PATH/data'

# function to generate terminal data
def generate_terminal_details(n_terminals=100, random_state=42):
    np.random.seed(random_state)

    terminal_props=[]

    for terminal_id in range(1,n_terminals+1):
        x_terminal_id = np.random.uniform(0,100)
        y_terminal_id = np.random.uniform(0,100)
        
        terminal_props.append([terminal_id,
                                      x_terminal_id, y_terminal_id])
                                       
    terminal_profiles_table = pd.DataFrame(terminal_props, columns=['TERMINAL_ID',
                                                                    'x_terminal_id', 'y_terminal_id'])
    
    return terminal_profiles_table

if __name__=="__main__":
    from sys import argv
    n=int(argv[1])
    terminal_df=generate_terminal_details(n_terminals=n)
    # print(card_df.head(3))
    terminal_df.to_csv(f'{PATH}/table_terminals_n-{n}.csv',index=False)