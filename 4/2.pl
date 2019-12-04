use strict;
use warnings;

sub int_to_digits {
  return map(int, split('', "$_[0]"));
}

sub is_valid_password {
  my $password_length = 6;

  # Turn the first argument into an array of digits
  my @password = int_to_digits($_[0]);

  # Check password length
  if (scalar @password != $password_length) {
    return 0;
  }

  my $has_double_digit = 0;

  for (my $i = 0; $i < $password_length - 1; $i++) {
    my $digit = $password[$i];

    # Check for decreasing digit
    if ($password[$i + 1] < $digit) {
      return 0;
    }

    # Check double digit
    if ($password[$i + 1] == $digit) {
      my $previous_equal = $password[$i - 1] && $password[$i - 1] == $digit;
      my $second_next_equal = $password[$i + 2] && $password[$i + 2] == $digit;
      
      if (!$previous_equal && !$second_next_equal) {
        $has_double_digit = 1;
      }
    }
  }

  return $has_double_digit;
}

sub count_passwords {
  my ($lower, $higher) = @_;
  my $count = 0;

  while ($lower < $higher) {
    if (is_valid_password($lower)) {
      $count++;
    }

    $lower++;
  }

  return $count;
}

open(my $file, '<', 'input.txt') or die;
my @input = map(int, split('-', <$file>));
my $password_count = count_passwords($input[0], $input[1]);
print "$password_count\n";
