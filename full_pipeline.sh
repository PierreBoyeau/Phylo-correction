set -e

# Important hyperparameters
max_seqs=1024
max_sites=1024
armstrong_cutoff=8.0

# Irrelevant hyperparameters
n_process=32
expected_number_of_MSAs=15051
max_families=16

# Input data directories
# Directory where the MSAs are found.
a3m_dir=a3m
# Directory where the pdb files are found
pdb_dir=pdb

# Output data directories
# Where the phylogenies will be stored
tree_dir=trees_"$max_seqs"_seqs_"$max_sites"_sites
# Where the contacts will be stored
contact_dir=contacts_"$armstrong_cutoff"
# Where the maximum parsimony reconstructions will be stored
maximum_parsimony_dir=maximum_parsimony_"$max_seqs"_seqs_"$max_sites"_sites
# Where the transitions obtained from the maximum parsimony phylogenies will be stored
transitions_dir=transitions_"$max_seqs"_seqs_"$max_sites"_sites
# Where the transition matrices obtained by quantizing transition edges will be stored
matrices_dir=matrices_"$max_seqs"_seqs_"$max_sites"_sites
# Where the co-transitions obtained from the maximum parsimony phylogenies will be stored
co_transitions_dir=co_transitions_"$max_seqs"_seqs_"$max_sites"_sites_"$armstrong_cutoff"
# Where the co-transition matrices obtained by quantizing transition edges will be stored
co_matrices_dir=co_matrices_"$max_seqs"_seqs_"$max_sites"_sites_"$armstrong_cutoff"

# # First we need to generate the phylogenies
# pushd phylogeny_generation
# echo "Running phylogeny_generation.sh"
# bash phylogeny_generation.sh ../"$a3m_dir" "$max_seqs" "$max_sites" "$n_process" ../"$tree_dir" "$expected_number_of_MSAs" "$max_families"
# popd

# # Generate the contacts
# pushd contact_generation
# echo "Running contact_generation.sh"
# bash contact_generation.sh ../"$pdb_dir" "$n_process" ../"$contact_dir" "$armstrong_cutoff" "$expected_number_of_MSAs" "$max_families"
# popd

# # Generate the maximum parsimony reconstructions
# pushd maximum_parsimony
# echo "Running maximum_parsimony.sh"
# bash maximum_parsimony.sh ../"$a3m_dir" ../"$tree_dir" ../"$maximum_parsimony_dir" "$n_process" "$expected_number_of_MSAs" "$max_families"
# popd

# # Generate single-site transitions
# pushd transition_extraction
# echo "Running transition_extraction.sh"
# bash transition_extraction.sh ../"$a3m_dir" ../"$maximum_parsimony_dir" ../"$transitions_dir" "$n_process" "$expected_number_of_MSAs" "$max_families"
# popd

# # Generate single-site transition matrices
# pushd matrix_generation
# echo "Running matrix_generation.sh"
# bash matrix_generation.sh ../"$a3m_dir" ../"$transitions_dir" ../"$matrices_dir" "$n_process" "$expected_number_of_MSAs" "$max_families" 1
# popd

# # Generate co-transitions
# pushd co_transition_extraction
# echo "Running co_transition_extraction.sh"
# bash co_transition_extraction.sh ../"$a3m_dir" ../"$maximum_parsimony_dir" ../"$co_transitions_dir" "$n_process" "$expected_number_of_MSAs" "$max_families" ../"$contact_dir"
# popd

# Generate co-transition matrices
pushd matrix_generation
echo "Running matrix_generation.sh"
bash matrix_generation.sh ../"$a3m_dir" ../"$co_transitions_dir" ../"$co_matrices_dir" "$n_process" "$expected_number_of_MSAs" "$max_families" 2
popd
