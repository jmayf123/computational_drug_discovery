import pandas as pd
import numpy as np 
from chembl_webresource_client.new_client import new_client

# Target search function
def target_search(target_name):
    target = new_client.target
    res = target.filter(pref_name__icontains = target_name)
    targets = pd.DataFrame(res)
    return(targets) #Returns a df of targets matching your search term

#Bioactivty data after getting target selection   
def get_bioactivities_data(target_chembl_ID):
    activity = new_client.activity
    res = activity.filter(target_chembl_id=target_chembl_ID).filter(standard_type="IC50")
    df = pd.DataFrame(res)
    return(df)
