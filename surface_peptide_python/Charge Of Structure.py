from Bio.PDB import *
from Bio.SeqUtils.IsoelectricPoint import IsoelectricPoint as IP
import os

#Download the PDB file
pdbl = PDBList()
structure_id = input("Structure id=") 
pdbl.retrieve_pdb_file(structure_id, file_format='pdb', pdir= os.getcwd())
pdb_dir = os.path.join(os.getcwd(), ('pdb' + structure_id + '.ent'))
print("pdb directory is here =", pdb_dir)

#Parse the PDB file
parser = PDBParser(QUIET=1)
structure = parser.get_structure(structure_id, pdb_dir)

#Calculating the charge of structure
ppb=PPBuilder()
for pp in ppb.build_peptides(structure):
    print(pp.get_sequence())