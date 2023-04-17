const CreateLongestPrefixSuffixTable = (searchWord)=> {
    const patternTable = [0];
    let prefixIndex = 0;
    let suffixIndex = 1;
  
    while (suffixIndex < searchWord.length) {
      if (searchWord[prefixIndex] === searchWord[suffixIndex]) {
        patternTable[suffixIndex] = prefixIndex + 1;
        suffixIndex += 1;
        prefixIndex += 1;
      } else if (prefixIndex === 0) {
        patternTable[suffixIndex] = 0;
        suffixIndex += 1;
      } else {
        prefixIndex = patternTable[prefixIndex - 1];
      }
    }
  
    return patternTable;
  }
  
//Return a number greater than zero for a match and -1 for mismatch
const Search = (text, searchWord)=> {
    let textIndex = 0;
    let searchWordIndex = 0;
    
    //preprocess the pattern table of the longest prefix suffix values of searchWord
    const patternTable = CreateLongestPrefixSuffixTable(searchWord);
  
    while (textIndex < text.length) {
      if (text[textIndex] === searchWord[searchWordIndex]) {
        //A match was found
        if (searchWordIndex === (searchWord.length - 1)) {

          return (textIndex - searchWord.length) + 1;
        }
        searchWordIndex += 1;
        textIndex += 1;
      } else if (searchWordIndex > 0) {
        searchWordIndex = patternTable[searchWordIndex - 1];
      } else {
        searchWordIndex = 0;
        textIndex += 1;
      }
    }
  
    return -1;
  }

//let searchText = "UUHHHJHIIJJJJJ HFDHFGHB JKFGIUYT JHGKJFUFT DFHGVJKGJHGJVBB VJVGGF";
//let searchWord = "HFDHFGHB";
//const index = Search(searchText,searchWord);
//document.write(index>0?`${searchWord} found at index ${index}`:"Word not found");
console.log(index);