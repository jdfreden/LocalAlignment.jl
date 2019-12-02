function score(seq1, seq2, sim_mat, sim_mat_header, affine)

    score_mat = init_scoring_matrix(seq1, seq2)
    traceback_mat = init_traceback_matrix(seq1, seq2)

    if affine == false
        score_non_affine(seq1, seq2, score_mat, traceback_mat, sim_mat, sim_mat_header)
    else
        score_affine(seq1, seq2, score_mat, traceback_mat, sim_mat, sim_mat_header)
    end






end


function score_non_affine(seq1, seq2, score_mat, traceback_mat, sim_mat, sim_mat_header)
    coordinates = []
    scores = []
    indices_max = (-1, -1)
    max_score = -1

    for row in 2:size(score_mat, 1)
        for col in 2:size(score_mat, 2)
            seq1_char_ind = search_header(sim_mat_header, seq1[col])
            seq2_char_ind = search_header(sim_mat_header, seq2[row])
            up = score_mat[row - 1, col] + sim_mat[seq1_char_ind, length(sim_mat_header)]
            left = score_mat[row, col - 1] + sim_mat[length(sim_mat_header), seq2_char_ind]
            diag = score_mat[row - 1, col - 1] + sim_mat[seq2_char_ind, seq1_char_ind]

            candidates = [0, diag, up, left]
            index = argmax(candidates)

            if candidates[index] > max_score
                max_score = candidates[index]
                indices_max = (row, col)
            end
            traceback_mat[row, col] = index - 2
            score_mat[row, col] = candidates[index]
            append!(scores, candidates[index])
            append!(coordinates, [[row, col]])
        end
    end

    order = sortperm(scores, rev = true)


    ret = Dict([("Score", max_score), ("col", indices_max[2]), ("row", indices_max[1]), ("coors", coordinates[order]), ("scores", scores[order]), ("score_matrix", score_mat), ("traceback_matrix", traceback_mat)])
    return(ret)

end



function score_affine(seq1, seq2, score_mat, traceback_mat, sim_mat, sim_mat_header)
    indices_max = (-1, -1)
    max_mat = "NONE"
    max_score = -1

    P = zeros(Int64, length(seq2), length(seq1))
    Q = zeros(Int64, length(seq2), length(seq1))
    D = zeros(Int64, length(seq2), length(seq1))

    trace_mat = zeros(Int8, length(seq2), length(seq1))

    for row in 2:size(D, 1)
        for col in 2:size(D, 2)
            #println(row, col)
            if row == 2
                P[row, col] = sim_mat[size(sim_mat, 1) - 1, 1] + sim_mat[size(sim_mat, 1), 1]
            else
                p1 = D[row - 1, col] + sim_mat[size(sim_mat, 1) - 1, 1] + sim_mat[size(sim_mat, 1), 1]
                p2 = P[row - 1, col] + sim_mat[size(sim_mat, 1), 1]
                P_cand = [p1, p2]
                P[row, col] = P_cand[argmax(P_cand)]
            end

            if col == 2
                Q[row, col] = sim_mat[size(sim_mat, 1) - 1, 1] + sim_mat[size(sim_mat, 1), 1]
            else
                q1 =  D[row, col - 1] + sim_mat[size(sim_mat, 1) - 1, 1] + sim_mat[size(sim_mat, 1), 1]
                q2 =  Q[row, col - 1] + sim_mat[size(sim_mat, 1), 1]
                Q_cand = [q1, q2]
                Q[row, col] = Q_cand[argmax(Q_cand)]
            end
            #D
            seq1_char_ind = search_header(sim_mat_header, seq1[col])
            seq2_char_ind = search_header(sim_mat_header, seq2[row])
            d1 = D[row - 1, col - 1] + sim_mat[seq2_char_ind, seq1_char_ind]
            D_cand = [0, d1, P[row, col], Q[row, col]]

            index = argmax(D_cand)
            if D_cand[index] > max_score
                max_score = D_cand[index]
                indices_max = (row, col)
            end

            D[row, col] = D_cand[index]
            trace_mat[row, col] = index - 2

            #println(p1, p2)
        end
    end
    ret = Dict([("Score", max_score), ("col", indices_max[2]), ("row", indices_max[1]), ("trace_matrix", trace_mat)])
    return(ret)
end
