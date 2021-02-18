
export function passesChecks(text){
  if (!Number.isNaN(parseInt(text))) {
    if (text.length === 4) {
      if (text[0] !== "0"){
        let set = uniq(text.split(''));
        if (set.length === 4){
          return {value: true, message: ""};
        } else {
          return {value: false, message: "All digits must be unique."}
        }
      } else {
        return {value: false, message: "First digit cannot be 0."};
      }
    } else {
      return {value: false, message: "Need exactly 4 digits."};
    }
  } else {
    return {value: false, message: "Numbers only please."};
  }
}

export function findBC(number, text){
  let cows = 0;
  let bulls = 0;
  for(let i = 0; i < 4; i++){
    if(number[i] === text[i]){
      bulls++;
    } else if (number.split('').includes(text[i])){
      cows++;
    }
  }
  return [bulls, cows];
}

// This function was taken from Nat Tuck's hangman code.
function uniq(xs) {
    return Array.from(new Set(xs));
}
