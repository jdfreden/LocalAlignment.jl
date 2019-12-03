function traceback(col, row, traceback_mat, score_mat, seq1, seq2)

    seq1_align = ""
    seq2_align = ""
    while score_mat[row, col] != 0
        if traceback_mat[row, col] == 0
            char_to_add1 = seq1[col]
            char_to_add2 = seq2[row]
            col = col - 1
            row = row - 1
        elseif traceback_mat[row, col] == 1
            char_to_add1 = '-'
            char_to_add2 = seq2[row]
            row = row - 1
        else
            char_to_add1 = seq1[col]
            char_to_add2 = '-'
            col = col - 1
        end
        seq1_align = char_to_add1 * seq1_align
        seq2_align = char_to_add2 * seq2_align
    end
    println(seq1_align)
    println(seq2_align)

    return([seq1_align, seq2_align])
end
