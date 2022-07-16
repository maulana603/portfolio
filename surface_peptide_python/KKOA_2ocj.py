# This is the program to predict the sequence of 
# designed peptide for the surface of folded proteins
# using one by all neighbor interaction assumption.
# Program is written by Maulana Ariefai.

from Bio.PDB import *
import os
from Bio.PDB.DSSP import DSSP

# Change this part to your folder directory
os.chdir(r'C:\cygwin64\home\maula\Project\Project 2')

#Ubuntu
# os.chdir(r'/media/maulana/OS/cygwin64/home/maula/Project/Project 2')

# Switching between three, one, and index of amino acids
Jernigan_aa_names = [
    "CYS",
    "MET",
    "PHE",
    "ILE",
    "LEU",
    "VAL",
    "TRP",
    "TYR",
    "ALA",
    "GLY",
    "THR",
    "SER",
    "ASN",
    "GLN",
    "ASP",
    "GLU",
    "HIS",
    "ARG",
    "LYS",
    "PRO",
]

aaj1 = "CMFILVWYAGTSNQDEHRKP"
aaj3 = Jernigan_aa_names

d1_to_index = {}
dindex_to_1 = {}
d3_to_index = {}
dindex_to_3 = {}

# Create some lookup tables
for i in range(0, 20):
    n1 = aaj1[i]
    n3 = aaj3[i]
    d1_to_index[n1] = i
    dindex_to_1[i] = n1
    d3_to_index[n3] = i
    dindex_to_3[i] = n3


def index_to_onej(index):
    """Index to corresponding one letter amino acid name according to Jernigan Sequence.

    >>> index_to_one(0)
    'C'
    >>> index_to_one(19)
    'P'
    """
    return dindex_to_1[index]


def one_to_indexj(s):
    """One letter code to index according to Jernigan Sequence.

    >>> one_to_index('A')
    0
    >>> one_to_index('Y')
    19
    """
    return d1_to_index[s]


def index_to_threej(i):
    """Index to corresponding three letter amino acid name according to Jernigan Sequence.

    >>> index_to_three(0)
    'ALA'
    >>> index_to_three(19)
    'TYR'
    """
    return dindex_to_3[i]


def three_to_indexj(s):
    """Three letter code to index according to Jernigan Sequence.

    >>> three_to_index('ALA')
    0
    >>> three_to_index('TYR')
    19
    """
    return d3_to_index[s]


def three_to_onej(s):
    """Three letter code to one letter code.

    >>> three_to_one('ALA')
    'A'
    >>> three_to_one('TYR')
    'Y'

    For non-standard amino acids, you get a KeyError:

    >>> three_to_one('MSE')
    Traceback (most recent call last):
       ...
    KeyError: 'MSE'
    """
    i = d3_to_index[s]
    return dindex_to_1[i]


def one_to_threej(s):
    """One letter code to three letter code.

    >>> one_to_three('A')
    'ALA'
    >>> one_to_three('Y')
    'TYR'
    """
    i = d1_to_index[s]
    return dindex_to_3[i]


# extracting tuple into seq number for residue
def resnum(lel, id, lol):
    return id


# Input the eij energy as a dictionary
eij = {}
i = 0
with open('KK_new_pot.txt', 'r') as f:
    # reading each line
    for line in f:
        # reading each energy
        j = 0
        for energy in line.split():
            eij[(aaj3[i], aaj3[j])] = float(energy)
            j += 1
        i += 1


# Input the eir energy as a dictionary
eir = {}
with open('KK_new_eir.txt', 'r') as f:
    # reading each line
    for line in f:
        # reading each energy
        i = 0
        for energy in line.split():
            eir[aaj3[i]] = float(energy)
            i += 1


# Calculating the eij and save as dictionary
potential = {}
for i in aaj3:
    for j in aaj3:
        potential[(i, j)] = (
            eij[(i, j)] + (sum(eir.values()) / len(eir))
            - eir[i] - eir[j])


# # Download the PDB file
# pdbl = PDBList()
# structure_id = input("Structure id=")
# pdb_dir = pdbl.retrieve_pdb_file(structure_id, file_format='pdb', pdir=os.getcwd())
# os.replace(pdb_dir, structure_id + ".pdb")
# pdb_dir = structure_id + ".pdb"
# print("pdb directory is here =", pdb_dir)

pdb_dir = "PCA_-5_-1renum.pdb"
doc_id = "PCA_-5_-1"

# Parse the PDB file
parser = PDBParser(QUIET=True)
structure = parser.get_structure(doc_id, pdb_dir)

# Extracting model, chain, and residue from structure
model = structure[0]
chains = model.child_list
res_list = Selection.unfold_entities(chains[0], "R")
print(chains[0])

# open output file
f = open('KKOA_PCA_-5_-1_result_test.txt', 'w')
f.write('Analyzed structure = {}\n'.format(doc_id))
f.write("Energy Matrix = KK new potential one by all\n")
f.write("Sequence =\n")

# initiating DSSP program
dssp = DSSP(model, pdb_dir, acc_array='Wilke')


res_start = []
atoms = []
atoms_contact = []
for residue in res_list:
    if residue.get_resname() in Jernigan_aa_names:
        #extracting rSASA from DSSP
        residue.rSASA = (dssp[(chains[0].get_id(), residue.get_id())])[3]
        # f.write(''.join(str(dssp[(chains[0].get_id(), residue.get_id())])))
        # f.write("\n")

        # Extracting CB or CA atoms with SASA parameter treshold from residues
        if residue.has_id("CB") and residue.rSASA > 0.2:
            # print(dssp[(chains[0].get_id(), residue.get_id())])
            atoms.append(residue["CA"])
            atoms_contact.append(residue["CB"])
            res_start.append(residue)
            # residue.select_atom = "CB"
            # print (residue.get_resname(), residue.select_atom ,(residue["CB"]).get_coord())
        elif residue.has_id("CA") and residue.rSASA > 0.2:
            # print(dssp[(chains[0].get_id(), residue.get_id())])
            atoms.append(residue["CA"])
            atoms_contact.append(residue["CA"])
            res_start.append(residue)
            # residue.select_atom = "CA"
            # print (residue.get_resname(), residue.select_atom ,(residue["CA"]).get_coord())
# print(len(res_start))
# print(len(atoms))
# print(len(atoms_contact))


# Declaring sequence, length of peptides, NeighborSearch Object, and Initial position
length = int(input("Input the length of peptide:"))
ns = NeighborSearch(atoms)
nc = NeighborSearch(atoms_contact)


# Calculating Interaction Energy wth the neigbor atoms included
for atom in atoms_contact:
    close_atoms = nc.search(atom.coord, 6, level='A')

    atom.get_parent().Eneighbor = 10.0
    for i in aaj3:
        Eneighbor_compare = 0
        for atom2 in close_atoms:
            res_atom = atom2.get_parent().get_resname()
            Eneighbor_compare += potential[(res_atom, i)]

        if Eneighbor_compare < atom.get_parent().Eneighbor:
            atom.get_parent().Eneighbor = Eneighbor_compare
            atom.get_parent().pair = i
    
    # print(atom.get_parent().get_id(), atom.get_parent().Eneighbor)


# Searching the lowest sequence for all surface residues
for residue in res_start:
    residue.total_energy = 0
    gap = 0.0
    j = 4
    sequence_pair = []
    sequence_number = []
    target_atom = residue["CA"]
    lowest_atom = residue["CA"]
    sequence_pair.append(target_atom)
    sequence_number.append(resnum(*target_atom.get_parent().get_id()))

    while len(sequence_pair) < length:
        # Searching for the neighbor atoms
        close_atoms = ns.search(target_atom.coord, j, level='A')
        close_atoms.remove(target_atom)

        # Remove the listed atoms from close atoms
        for atom in sequence_pair:
            if atom in close_atoms:
                close_atoms.remove(atom)

        # Choose the lowest neigbor atom and save the lowest energy
        lowest_neighbor = 10.0
        for atom in close_atoms:
            if atom.get_parent().Eneighbor < lowest_neighbor:
                lowest_atom = atom
                lowest_neighbor = atom.get_parent().Eneighbor

        #Adding glycine to gap between amino acids
        if lowest_atom != target_atom:
            gap += lowest_atom - target_atom - 3.8
            if gap > 7.6:
                sequence_pair.append("GLY")
                sequence_pair.append("GLY")
                sequence_number.append("GLY")
                sequence_number.append("GLY")
                gap -= 7.6
            elif gap > 3.8:
                sequence_pair.append("GLY")
                sequence_number.append("GLY")
                gap -= 3.8

        # Increase the search treshold if there is no residue that fulfills the requirement
        if lowest_atom in sequence_pair:
            if j == 4:
                j = 8
            elif j == 8:
                j = 12
            # Stop if there is no residue that fulfills the requirement until 12 amstrong
            else:
                print("Not enough residue that fulfilled the requirement")
                f.write('Next sequence does not have enough residue that fulfilled the requirement\n')
                break
        else:
            target_atom = lowest_atom
            # print(lowest_atom)
            sequence_pair.append(lowest_atom)
            sequence_number.append(resnum(*lowest_atom.get_parent().get_id()))
            residue.total_energy += lowest_neighbor
            j = 4
    
    residue.sequence_pair = ""
    # print(sequence_pair)
    for a in sequence_pair:
        if a == "GLY":
            residue.sequence_pair += three_to_onej("GLY")
        else:
            residue.sequence_pair += three_to_onej(a.get_parent().pair)
    residue.sequence_number = sequence_number

    # Printing to output file
    f.write('{} {} '.format(residue.sequence_pair, residue.total_energy))
    for number in sequence_number:
        f.write('{} '.format(number))
    f.write('\n')


# for atom in list_sequence:
#     print(atom.get_parent().__repr__())
f.close()