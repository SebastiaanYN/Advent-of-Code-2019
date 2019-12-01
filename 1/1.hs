toInts :: [String] -> [Int]
toInts = map read

massToFuel :: Int -> Int
massToFuel mass = mass `div` 3 - 2

main :: IO()
main = do
  file <- readFile "input.txt"
  let input = toInts $ lines file
  print $ sum $ map massToFuel input
