<?php
$input = file_get_contents('input.txt');
$opcodes = array_map('intval', explode(',', $input));
$ip = 0;

function getIndex($instruction, $index) {
  global $opcodes;
  global $ip;

  $mode = $instruction / pow(10, $index + 1) % 10;

  if ($mode === 0) {
    return $opcodes[$ip + $index - 1]; // position mode
  } else {
    return $ip + $index - 1; // immediate mode
  }
};

while (true) {
  $instruction = $opcodes[$ip++];
  $opcode = $instruction % 100; // last 2 digits

  switch ($opcode) {
    case 1:
      $a = $opcodes[getIndex($instruction, 1)];
      $b = $opcodes[getIndex($instruction, 2)];

      $opcodes[getIndex($instruction, 3)] = $a + $b;
      $ip += 3;
      break;

    case 2:
      $a = $opcodes[getIndex($instruction, 1)];
      $b = $opcodes[getIndex($instruction, 2)];

      $opcodes[getIndex($instruction, 3)] = $a * $b;
      $ip += 3;
      break;

    case 3:
      echo 'Input: ';
      $input = (int) fgets(STDIN);

      $opcodes[getIndex($instruction, 1)] = $input;
      $ip += 1;
      break;

    case 4:
      $output = $opcodes[getIndex($instruction, 1)];

      echo "$output\n";
      $ip += 1;
      break;

    case 5:
      $bool = $opcodes[getIndex($instruction, 1)];

      if ($bool !== 0) {
        $ip = $opcodes[getIndex($instruction, 2)];
      } else {
        $ip += 2;
      }

      break;

    case 6:
      $bool = $opcodes[getIndex($instruction, 1)];

      if ($bool === 0) {
        $ip = $opcodes[getIndex($instruction, 2)];
      } else {
        $ip += 2;
      }

      break;

    case 7:
      $a = $opcodes[getIndex($instruction, 1)];
      $b = $opcodes[getIndex($instruction, 2)];

      $opcodes[getIndex($instruction, 3)] = $a < $b ? 1 : 0;
      $ip += 3;
      break;

    case 8:
      $a = $opcodes[getIndex($instruction, 1)];
      $b = $opcodes[getIndex($instruction, 2)];

      $opcodes[getIndex($instruction, 3)] = $a === $b ? 1 : 0;
      $ip += 3;
      break;

    case 99:
      return;

    default:
      throw new Exception("Unknown opcode '$opcode'");
  }
}
?>
