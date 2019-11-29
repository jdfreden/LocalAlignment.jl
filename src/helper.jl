################################################################################
function parse_file(filepath)
    sequences = readdlm(filepath, '\n', String, '\n')

    seq1 = "-" * sequences[2]
    seq2 = "-" * sequences[4]
    sequences = [seq1, seq2]
    return(sequences)
end

################################################################################
function check_input(seq1, seq2, similarity_mat_header)
    possible_AAs = Set(similarity_mat_header)

    for c in split(seq1[2:length(seq1)], "")
        if in(c, possible_AAs) == false
            println(c, " is not included in the similarity matrix provided")
            exit(1)
        end
    end

    for c in split(seq2[2:length(seq2)], "")
        if in(c, possible_AAs) == false
            println(c, " is not included in the similarity matrix provided")
            exit(1)
        end
    end
end

################################################################################
function convert_simple_scoring(seq1, seq2, scoring_scheme, affine)
    if affine == false
        new_header = unique([split(sequences[1][2:length(sequences[1])],""); split(sequences[2][2:length(sequences[2])],""); "*"])
    else
        new_header = unique([split(sequences[1][2:length(sequences[1])],""); split(sequences[2][2:length(sequences[2])],""); "*"; "AFF"])
    end

    sim_mat = zeros(Int32, length(new_header), length(new_header))

    for row in 1:size(sim_mat, 1)
        for col in 1:size(sim_mat, 2)
            if row == col
                sim_mat[row,col] = scoring_scheme["match"]

            else
                if affine == true

                    if row == size(sim_mat,1) || col == size(sim_mat,2)
                        sim_mat[row,col] = scoring_scheme["gapExt"]
                    elseif row == size(sim_mat,1) - 1 || col == size(sim_mat,1) - 1
                        sim_mat[row,col] = scoring_scheme["gapCost"]
                    else
                        sim_mat[row,col] = scoring_scheme["mismatch"]
                    end

                else
                    if row == size(sim_mat,1) || col == size(sim_mat,2)
                        sim_mat[row,col] = scoring_scheme["gapCost"]
                    else
                        sim_mat[row,col] = scoring_scheme["mismatch"]
                    end

                end
            end
        end
    end
    return(sim_mat, new_header)
end

################################################################################
function init_scoring_matrix(seq1, seq2)

    score_mat = zeros(Int64, length(seq2), length(seq1))
    return(score_mat)
end

################################################################################
function init_traceback_matrix(seq1, seq2)

    traceback_mat = zeros(Int64, length(seq2), length(seq1))

    for i in 1:length(seq2)
        traceback_mat[i,1] = 1
    end

    for j in 1:length(seq1)
        traceback_mat[1,j] = 2
    end

    return(traceback_mat)
end
################################################################################

function search_header(header, query)
    ind = -1
    for i in range(1, stop = length(header))
        if header[i] == string(query)
            ind = i
            #println("FOUND ", query, " at ", ind)
            break
        end
    end
    return(ind)
end

################################################################################
