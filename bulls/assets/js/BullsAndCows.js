import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import * as Toastr from 'toastr';
import 'toastr/build/toastr.min.css';
import { useState } from 'react';
import { randNum, passesChecks, findBC, hasWon } from './bullfuncs';
import { ch_join, ch_push, ch_reset } from './socket';

function GameOver(props) {
  return (
    <div class="row">
    <div class="col-sm-6">
    <h1>Game Over!</h1>
    <brk/>
    <p>The number was {props.number}.</p>
    <p>Play again?</p>
    <button class="btn btn-success" onClick={props.onClick} type="button">
      Reset
    </button>
    </div>
    </div>
  );
}

function Victory(props) {
  return (
    <div class="row">
    <div class="col-sm-6">
        <h1>You won!</h1>
        <br/>
        <p>The number was {props.number}.</p>
        <p>Play again?</p>
        <button class="btn btn-success" onClick={props.onClick} type="button">
          Reset
        </button>
    </div>
    </div>);
}

function GuessTable(props) {
    return (
      <tbody>
        {props.guesses.map(guess => (
          <tr id={guess.key}>
            <td>{guess.value}</td>
            <td>{guess.bulls}B{guess.cows}C</td>
          </tr>
        ))}
      </tbody>
    );
}

function BullsAndCows() {
  const [state, setState] = useState({
    number: randNum(),
    guesses: [],
    text: ''
  })


  function updateText(ev) {
    let vv = ev.target.value;
    let cc = vv.substring(0, Math.min(vv.length, 4));
    setText(cc);
  }

  function keyPress(ev) {
    if (ev.key === "Enter") {
      guess();
    }
  }

  function resetGame(){
    setNumber(randNum());
    setGuesses([]);
    setText('');
  }

  function guess() {
    let check = passesChecks(text);
    if (check.value){
      let bullscows = findBC(number, text);
      const newGuess = {
        key: guesses.length,
        value: text,
        bulls: bullscows[0],
        cows: bullscows[1]
      }
      let ng = guesses.concat(newGuess);
      setGuesses(ng);
      setText('');
    } else {
      Toastr.error(check.message);
    }
  }

  let body = (
  <div class="row">
  <div class="col-sm-8">
  <h1 class="display-4">Bulls and Cows</h1>
  <div class="input-group mb-3">
  <input type="text" class="form-control"
    value={text}
    onChange={updateText}
    onKeyPress={keyPress}
    placeholder="Type a four-digit number here"/>
  <div class="input-group-append">
    <button class="btn btn-outline-danger" onClick={resetGame} type="button">
      Reset
    </button>
    <button class="btn btn-success" onClick={guess} type="button">
      Guess
    </button>
  </div>
  </div>
  <table class="table table-striped">
    <thead class="thead thead-light">
      <tr>
        <th>Guess</th>
        <th>Result</th>
      </tr>
    </thead>
      <GuessTable guesses={guesses}/>
  </table>
  </div>
  <div class="col-sm-4">
  <h1 class="display-4"> </h1>
  <ol>
    <li>When you guess, the game will tell you how many bulls (B) and cows (C) you
    got in that guess.</li>
    <li>A bull means the right number in the right place, and a
    cow means the right number in the wrong place.</li>
    <li>A guess should not have duplicate digits or a starting 0.</li>
    <li>You get a maximum of 8 guesses.</li>
  </ol>
  <p>
     Good luck!
  </p>
  </div>
  </div>);

  if (hasWon(guesses, number)) {
    body = (
      <Victory number={number} onClick={resetGame}/>);
  } else if (guesses.length > 7) {
    body = (
      <GameOver number={number} onClick={resetGame}/>);
  }

  return (
    <div class="container p-3 my-3">
    {body}
    </div>
  );
}

export default BullsAndCows;
