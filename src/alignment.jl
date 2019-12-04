function alignment(file_path; match = nothing, mismatch = nothing, gap = nothing, gapext = nothing, similarity_matrix_path = nothing, percent_difference = nothing, write_viz_file = false)
    sequences = parse_file(file_path)
    affine = false


    if match != nothing && similarity_matrix_path != nothing
        throw(ArgumentError("Only use similarity_matrix_path or match/mismatch/gap/gapext"))
    elseif match == nothing && similarity_matrix_path == nothing
        println("No scoring parameters specified, using the Blosum62 matrix")
        similarity_matrix, similarity_matrix_header = load_blosum()
        affine = true
    elseif match == nothing && similarity_matrix_path != nothing
        println("Using user-specified similarity matrix")
        similarity_matrix, similarity_matrix_header = parse_similiarity_matrix_file(similarity_matrix_path)
        if in("AFF", similarity_matrix_header)
            affine = true
        end
    else
        if match != nothing && mismatch != nothing && gap != nothing && gapext == nothing
            similarity_matrix, similarity_matrix_header = convert_simple_scoring(sequences, Dict([("match", match), ("mismatch", mismatch), ("gapCost", gap)]), false)
        elseif match != nothing && mismatch != nothing && gap != nothing && gapext != nothing
            similarity_matrix, similarity_matrix_header = convert_simple_scoring(sequences, Dict([("match", match), ("mismatch", mismatch), ("gapCost", gap), ("gapExt", gapext)]), true)
            affine = true
        else
            throw(ArgumentError("Simple scoring scheme parameters were not complete (match, mismatch, or gap missing)"))
        end
    end

    scores = score(sequences[1], sequences[2], similarity_matrix, similarity_matrix_header, affine)

    if percent_difference == nothing
        println("percent_difference was not specified, Only returning optimal alignment")
        traceback(scores["col"], scores["row"], scores["traceback_matrix"], scores["score_matrix"], sequences[1], sequences[2])
    else
        #println("returning alignments whose scores are within " * string(percent_difference * 100) * "% of the max")
        sub_thres = determine_suboptimal_threshold(percent_difference, scores["Score"])
        sub_inds = broadcast(<=, sub_thres, scores["scores"])
        sub_scores = scores["scores"][sub_inds]
        sub_coors = scores["coors"][sub_inds]
        alignments = suboptimal_traceback(sub_coors, sub_scores, scores["traceback_matrix"], scores["score_matrix"], sequences[1], sequences[2])

        for i in 1:4:length(alignments)
            #println(i)
        end
    end

    if write_viz_file == true
        io = open("LocalAlignment_Visualization_sequences.csv", "w")
        string_to_write = sequences[1] * "," * sequences[2] * "\n"
        write(io, string_to_write)

        close(io)


        io = open("LocalAlignment_Visualization_file.csv", "w")
        for i in 1:2:length(alignments)
            alignment_name = alignments[i]
            positions = alignments[i + 1]
            string_to_write = alignment_name
            for p in positions
                string_to_write = string_to_write * "," * string(p)
            end
            string_to_write = string_to_write * "\n"
            write(io, string_to_write)
        end

        close(io)
    end

end
