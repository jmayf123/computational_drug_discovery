import pandas as pd
from padelpy import padeldescriptor

def make_ml_df(df3):

    df3_selection = df3[['canonical_smiles', 'molecule_chembl_id']]
    df3_selection.to_csv('molecule.smi', sep='\t', index=False, header=False)

    fingerprint_output_file = 'PubChem.csv'
    fingerprint_descriptortypes = 'PubchemFingerprinter.xml'

    padeldescriptor(mol_dir='molecule.smi', 
                    d_file=fingerprint_output_file, 
                    descriptortypes= fingerprint_descriptortypes,
                    detectaromaticity=True,
                    standardizenitro=True,
                    standardizetautomers=True,
                    threads=2,
                    removesalt=True,
                    log=True,
                    fingerprints=True)


    fingerprints = pd.read_csv(fingerprint_output_file)

    df_ml = pd.concat([fingerprints, df3['pIC50']], axis=1).dropna()

    return(df_ml)
