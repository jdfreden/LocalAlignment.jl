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
    return(Dict([("seq1", seq1_align), ("seq2", seq2_align)]))
end


function suboptimal_traceback(coors, scores, traceback_mat, score_mat, seq1, seq2)
    bin_mat = BitArray(undef, length(seq2), length(seq1))
    alignments = []
    seq1_align = ""
    seq2_align = ""
    for i in range(1, stop = length(coors))
        row = coors[i][1]
        col = coors[i][2]
        s = scores[i]
        seq1_align = ""
        seq2_align = ""
        if bin_mat[row,col] == 1
            continue
        end
        while score_mat[row, col] != 0
            bin_mat[row, col] = true
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
        println(s)
        println("-----------")
        seq1_name = "seq1." * string(i)
        seq2_name = "seq2." * string(i)
        append!(alignments, [[[seq1_name, seq1_align], [seq2_name, seq2_align]]])

    end
    return(alignments)
end
