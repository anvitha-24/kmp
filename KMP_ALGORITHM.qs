namespace KMP_Algorithm {
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    @EntryPoint()
    operation init() : Unit {
        // Here we use an array of characters to represent a sentence
        let words = ["j", "h", "g", "f", "j", "h", "f", "g", "k", "j", "h", "g", "j"];
        let searchWord = ["s", "g", "s"];
        let index = KMP(words, searchWord);
        Message($"Index of search word: {index}");
    }

    operation encodeStringArray(arrayText : String[]) : Qubit[] {
        use qubits = Qubit[Length(arrayText)];
        ApplyToEach(H, qubits);

        for (i in 0 .. Length(arrayText) - 1) {
            let amplitude = Sqrt(1.0 / IntAsDouble(Length(arrayText))) * Sqrt(1.0 / IntAsDouble(Length(arrayText)));
            ControlledOnInt(0, i, ApplyToEachA(H, qubits));
            ControlledOnInt(0, i, ApplyToEachA(H, qubits));
        }
        
        return qubits;
    }

    function KMP(text : String[], pattern : String[]) : Int {
        // Calculate the prefix table for the pattern.
        let prefixTable = CalculatePrefixTable(pattern);

        mutable patternIndex = 0;
        mutable textIndex = 0;

        // Loop over text until a match is found

        while (textIndex < Length(text)) {
            if (text[textIndex] == pattern[patternIndex]) {
                set patternIndex = patternIndex + 1;
                set textIndex = textIndex + 1;

                // If we have reached the end of the pattern, a match has been found.
                if (patternIndex == Length(pattern)) {
                    return textIndex - patternIndex;
                }
            }
            elif (patternIndex > 0) {
                set patternIndex = prefixTable[patternIndex - 1];
            }
            else {
                set textIndex = textIndex + 1;
            }
        }

        // If no match was found, return -1.
        return -1;
    }


    function CalculatePrefixTable(pattern : String[]) : Int[] {
        // Initialize variables for the prefix table and the length of the longest prefix that is also a suffix.
        mutable prefixTable = EmptyArray<Int>();
        
        mutable longestPrefixSuffix = 0;

        // Iterate over the pattern, calculating the prefix table.
        for i in 1 .. Length(pattern) - 1 
        {
            while (longestPrefixSuffix > 0 and pattern[i] != pattern[longestPrefixSuffix]) {
                set longestPrefixSuffix = prefixTable[longestPrefixSuffix - 1];
            }

            if (pattern[i] == pattern[longestPrefixSuffix]) {
                set longestPrefixSuffix = longestPrefixSuffix + 1;
            }
            set prefixTable = prefixTable + [longestPrefixSuffix];
        }

        // Return the prefix table.
        return prefixTable;
    }
}
