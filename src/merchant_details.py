# this file contains the code for creating the merchant and merchant_id table
# the merchant table contains:
# 1. merchant_id
# 2. merchant

# the merchant_type table contains:
# 1. merchant_type_id
# 2. merchant_type

# import libraries
import pandas as pd
import pickle as pi

PATH='YOUR PATH/data'

# class to generate the merchant and merchant_type table
class Mechant_details():
    def __init__(self,merchant_info):
        self.merchants=[i[0] for i in merchant_info]
        self.merchant_types=[i[1].lower() for i in merchant_info]
        self.unique_types=list(set([i.lower() for i in self.merchant_types]))

    def merchant_table(self):
        deats=[]
        for index,me in enumerate(self.merchants):
            me_type=self.unique_types.index(self.merchant_types[index])
            deats.append([index+1, me, me_type+1])    

        merch_df= pd.DataFrame(data=deats, columns=['id','merchant','merchant_type'])
        return merch_df

    def merchant_type_table(self):
        return pd.DataFrame(data=[[i+1,j] for i,j in enumerate(self.unique_types)],
                                    columns=['id','merchant_type'])

if __name__=="__main__":

    # we can also get the questions
    with open(PATH+'/merchant_info.pickle','rb') as f:
        m_info=pi.load(f)

    # generating the merchant related tables
    obj=Mechant_details(m_info)
    merchant_table= obj.merchant_table()
    merchant_type_table= obj.merchant_type_table()

    # save the dataframes
    merchant_table.to_csv(f'{PATH}/table_merchant.csv',index=False)
    merchant_type_table.to_csv(f'{PATH}/table_merchant_type.csv',index=False)


