using LocalAlignment


file = "test/files/scoring_test.fasta"
file2 = "test/files/test_affine.fasta"
file3 = "test/files/test_strings.fasta"
file4 = "test/files/test_large_proteins.fasta"
file5 = "test/files/test_3.fasta"
medium_protein = "test/files/test_medium_proteins.fasta"
file6 = "test/files/test_4.fasta"

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
simple_scores = LocalAlignment.score(sequences[1], sequences[2], simple_similarity_matrix, simple_similarity_matrix_header, false)

#score simple scoring affine
affine_scores = LocalAlignment.score(sequences[1], sequences[2], affine_similarity_matrix, affine_similarity_matrix_header, true)


#traceback for simple scoring non affine
LocalAlignment.traceback(simple_scores["col"], simple_scores["row"], simple_scores["traceback_matrix"], simple_scores["score_matrix"], sequences[1], sequences[2])

#traceback for simple scoring affine
LocalAlignment.traceback(affine_scores["col"], affine_scores["row"], affine_scores["traceback_matrix"], affine_scores["score_matrix"], sequences[1], sequences[2])

#suboptimal traceback for simple scoring non affine

sub_threshold = LocalAlignment.determine_suboptimal_threshold(.1, simple_scores["Score"])

sub_inds = broadcast(<=, sub_threshold, simple_scores["scores"])

sub_scores = simple_scores["scores"][sub_inds]
sub_coors = simple_scores["coors"][sub_inds]


LocalAlignment.suboptimal_traceback(sub_coors, sub_scores, simple_scores["traceback_matrix"], simple_scores["score_matrix"], sequences[1], sequences[2])


@time LocalAlignment.alignment("test/files/performance/length_n.fasta", percent_difference = .3)

LocalAlignment.alignment(file4, match = 1, mismatch = -1, gap = -2)
