toInts :: [String] -> [Int]
toInts = map read

massToFuel :: Int -> Int
massToFuel mass = do
  let fuel = mass `div` 3 - 2
  if fuel < 0
    then 0
    else fuel + massToFuel fuel

main :: IO()
main = do
  file <- readFile "input.txt"
  let input = toInts $ lines file
  print $ sum $ map massToFuel input
