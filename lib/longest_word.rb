require 'open-uri'
require 'json'

def generate_grid(grid_size)
  alphabet = ("A".."Z").to_a
  vowels = ["A","E","I","O","U"]
  some_vowels = (grid_size / 3).times.map { vowels[rand(0..vowels.length - 1)] }
  grid = grid_size.times.map { alphabet[rand(0..alphabet.length - 1)] } << some_vowels
  grid
  # this method generates an array.
end

def run_game(attempt, grid, start_time, end_time)
  not_in_the_grid = false
  url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=72f7b161-ab8a-406b-a730-97dca97fe8de&input="+attempt
  string_from_api = open(url).read
  # string_from_api = '{"outputs":[{"output":"chariot","stats":{"elapsed_time":19,"nb_characters":5,"nb_tokens":1,"nb_tus":1,"nb_tus_failed":0}}]}'
  hash_from_api = JSON.parse(string_from_api)
  # check if attempt is composed of grid elements:
  attempt.upcase.split("").each do |letter|
    if grid.include?(letter) == false
      not_in_the_grid = true
    else
      grid.delete(letter)
    end
  end
  # get variables from hash_from_api["outputs"]
  translation = hash_from_api["outputs"][0]["output"]
  elapsed_time = end_time - start_time

  # Check if in the grid and if an english word:
  if not_in_the_grid == true
    translation = nil
    score = 0
    message = "not in the grid"
  elsif attempt == translation
    translation = nil
    score = 0
    message = "not an english word"
  else
    score = attempt.length / elapsed_time * 10
    message = mess_gen(score)
  end
  # hash_from_api["outputs"]
  {
    translation: translation,
    time: elapsed_time,
    score: score,
    message: message
  }
  # TODO: runs the game and return detailed hash of result
end

def mess_gen(score)
  if score < 1
    "Bad score!"
  else
    "well done"
  end
end
