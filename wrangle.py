import pandas as pd
import numpy as np

import env

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler, RobustScaler, StandardScaler



def get_connection(db_name):
    '''
    This function uses my info from my env file to
    create a connection url to access the sql database.
    '''
    from env import host, user, password
    return f'mysql+pymysql://{user}:{password}@{host}/{db_name}'


def get_zillow():
    '''
    This function pulls in the zillow dataframe from my sql query. I specified
    columns from sql to bring in.
    '''

    sql_query = '''
    SELECT *
    FROM properties_2017
    JOIN predictions_2017 USING (parcelid)
    INNER JOIN (SELECT parcelid, MAX(transactiondate) AS transactiondate
                    FROM predictions_2017
                    GROUP BY parcelid) 
                AS t USING (parcelid, transactiondate)
    LEFT JOIN airconditioningtype USING (airconditioningtypeid)
    LEFT JOIN architecturalstyletype USING (architecturalstyletypeid)
    LEFT JOIN buildingclasstype USING (buildingclasstypeid)
    LEFT JOIN heatingorsystemtype USING (heatingorsystemtypeid)
    LEFT JOIN propertylandusetype USING (propertylandusetypeid)
    LEFT JOIN storytype USING (storytypeid)
    LEFT JOIN typeconstructiontype USING (typeconstructiontypeid)
    WHERE properties_2017.latitude IS NOT NULL
    OR properties_2017.longitude IS NOT NULL;
    '''
    
    return pd.read_sql(sql_query, get_connection('zillow'))



def split_data(df):
    '''
    This function takes in a dataframe and splits it into train, test, and 
    validate dataframes for my model
    '''

    train_validate, test = train_test_split(df, test_size=.2, 
                                        random_state=123)
    train, validate = train_test_split(train_validate, test_size=.3, 
                                   random_state=123)

    print('train--->', train.shape)
    print('validate--->', validate.shape)
    print('test--->', test.shape)
    return train, validate, test