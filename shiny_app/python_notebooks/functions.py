import pandas as pd
import numpy as np 
from chembl_webresource_client.new_client import new_client

# Target search function
def target_search(target_name):
    target = new_client.target
    res = target.filter(pref_name__icontains = target_name)
    if len(res) > 200:
        raise ValueError('Search Target too broad, Try Another Search Term.')
    else:
        targets = pd.DataFrame(res)
        return(targets) #Returns a df of targets matching your search term

#Bioactivty data after getting target selection   
def get_bioactivities_data(target_chembl_ID):
    activity = new_client.activity
    res = activity.filter(target_chembl_id=target_chembl_ID).filter(standard_type="IC50").only(['molecule_chembl_id','canonical_smiles','standard_value', 'standard_type'])
    df = pd.DataFrame(res[0:500])#Set a limit for now, take too long to compute over 500 activities
    df['standard_value'] = df['standard_value'].astype(float)
    
    conditions = [
        (df['standard_value'] >= 10000),
        (df['standard_value'] <= 1000)
    ]
    choices = ['inactive', 'active']
    df['bioactivity_class'] = np.select(conditions, choices, default = 'intermediate')
    return(df)
