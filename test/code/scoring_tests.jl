using LocalAlignment
using DelimitedFiles

file = "test/files/scoring_test.fasta"

sequences = LocalAlignment.parse_file(file)

simple_scoring_scheme = Dict([("match", 1), ("mismatch", -1), ("gapCost", -2)])
affine_scoring_scheme = Dict([("match", 3), ("mismatch", -1), ("gapCost", -2), ("gapExt", -1)])

#create the matrix for simple_scoring_scheme
simple_similarity_matrix, simple_similarity_matrix_header = LocalAlignment.convert_simple_scoring(sequences, simple_scoring_scheme, false)

#create the matrix for affine scoring scheme
affine_similarity_matrix, affine_similarity_matrix_header = LocalAlignment.convert_simple_scoring(sequences, affine_scoring_scheme, true)

#create augmented blosum62 matrix
blosum_62, blosum_62_header = LocalAlignment.load_blosum()


#score simple scoring non affine
LocalAlignment.score(sequences[1], sequences[2], simple_similarity_matrix, simple_similarity_matrix_header, false)

#score simple scoring affine
LocalAlignment.score(sequences[1], sequences[2], affine_similarity_matrix, affine_similarity_matrix_header, true)
