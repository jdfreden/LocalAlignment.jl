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


##TS1.2
failed_header = ["T", "C", "V", "W", "H", "P"]        #Missing the A
correct_header = ["A", "T", "C", "V", "W", "H", "P"]

if !(LocalAlignment.check_input(sequences[1], sequences[2], correct_header))
    println("TS1.2 HAS FAILED")
end

try
    LocalAlignment.check_input(sequences[1], sequences[2], failed_header)
    println("TS1.2 HAS FAILED")
catch ArgumentError
    
end
