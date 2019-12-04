#LocalAlignment.jl

**THIS WAS DONE FOR A CLASS. DO NOT USE FOR PRODUCTION**

This is package for performing pairwise Smith-Waterman local alignment. Orginally developed for aligning protein sequences, this package is capable of locally aligning any pair of strings given in FASTA format. Alignment methods included are:
  * optimal Smith-Waterman local alignment
  * local alignment with affine gaps (Gotoh, 1982)
  * suboptimal alignment within a percent change of maximum score
  
Users can specify a simple scoring scheme including a match, mismatch, gap and optionally gap extension (affine gaps) score or a similarity/substitution matrix to provide a more biologically relevant alignments.

Users interface with the package through the driver function, 'alignment'. The usage of this function is described below:
```julia
function alignment(file_path; match = nothing, mismatch = nothing, gap = nothing, gapext = nothing,
                   similarity_matrix_path = nothing, percent_difference = nothing, write_viz_file = false)
```

file_path: Path to the sequences to be aligned written in FASTA format. This is the only required argument.  

match, mismatch, gap, gapext: Integers corresponding to the scores. If gapext is specified, then alignment will be done with affine gaps.

similarity_matrix_path: Path to a user-determined similarity/substitution matrix. 1st line should be the header of the matrix. The matrix should be a square matrix with the penalty for gaps given with the header GAP. If affine gap alignment is wanted with the matrix, the penalty for gap extension should be the last row and last column with the header EXT.

percent_difference: A float between 0 and 1. Used to calculate the allowable difference from the max score to be reported by suboptimal alignment. When this argument is given, the suboptimal alignment traceback will be used to return all non-overlapping alignments within the percent difference.

write_viz_file: When true, alignment will write 2 files to the current directory to be used for visualization using our R function.
