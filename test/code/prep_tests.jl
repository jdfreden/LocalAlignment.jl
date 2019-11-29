using LocalAlignment

####TEST SET 1
file1 = "test/files/test_file.fasta"
sequences = LocalAlignment.parse_file(file1)

##TS1.1
if !(sequences[1] == "-AATCVWHP")
    println("TS1.1 HAS FAILED")
end


if !(sequences[2] == "-TCVAWP")
    println("TS1.1 HAS FAILED")
end
