function traceback(col, row, traceback_mat, score_mat, seq1, seq2)

    seq1_align = ""
    seq2_align = ""
    s = score_mat[row, col]
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
    println(s)
    println()
    return(Dict([("seq1", seq1_align), ("seq2", seq2_align)]))
end


function suboptimal_traceback(coors, scores, traceback_mat, score_mat, seq1, seq2)
    #println(coors)
    #println(scores)
    bin_mat = zeros(Int8, length(seq2), length(seq1))
    alignments = []
    seq1_align = ""
    seq2_align = ""
    seq1_align_ind = []
    seq2_align_ind = []
    number_of_alignments = 1
    #println(coors[1])
    #print(length(coors))
    for i in range(1, stop = length(coors))
        row = coors[i][1]
        col = coors[i][2]
        s = scores[i]
        seq1_align = ""
        seq2_align = ""
        seq1_align_ind = []
        seq2_align_ind = []
        killed_alignment = false
        bin_mat_copy = deepcopy(bin_mat)
        while score_mat[row, col] != 0
            if bin_mat[row,col] != 1
                bin_mat[row, col] = 1
            else
                killed_alignment = true
                bin_mat = bin_mat_copy
                break
            end
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
            append!(seq1_align_ind, col)
            append!(seq2_align_ind, row)

        end

        if killed_alignment == false
            seq1_name = "seq1." * string(number_of_alignments)
            seq2_name = "seq2." * string(number_of_alignments)
            number_of_alignments = number_of_alignments + 1
            println(seq1_align)
            println(seq2_align)
            println(s)
            println("------------")
            append!(alignments, [seq1_name, seq1_align_ind, seq2_name, seq2_align_ind])
        end
    end
    return(alignments)
end
