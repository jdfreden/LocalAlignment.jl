LocalAlignment.jl

This is package for performing pairwise Smith-Waterman local alignment. Orginally developed for aligning protein sequences, this package is capable of locally aligning any pair of strings given in FASTA format. Alignment methods included are:
  * optimal Smith-Waterman local alignment
  * local alignment with affine gaps (Gotoh, 1982)
  * suboptimal alignment within a percent change of maximum score
  
Users can specify a simple scoring scheme including a match, mismatch, gap and optionally gap extension (affine gaps) score or a similarity/substitution matrix to provide a more biologically relevant alignments.


  
