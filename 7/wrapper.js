// This wrapper exists because I couldn't get it working with PHP directly
// It's pretty ugly but oh well

const child = require('child_process').spawn('php', ['intcode.php']);

function write(msg) {
  child.stdin.write(msg);
  child.stdin.write('\n');
}

const args = process.argv.slice(2);

write(args[0]);

if (args[1]) {
  write(args[1]);
}

child.stdout.on('data', data => {
  const msg = data
    .toString()
    .replace(/Input: /g, '')
    .trim();

  if (msg) {
    console.error(msg); // error is used to send the data to the other intcode program
    console.log(msg); // log is used to output to bash
  }
});

child.stdin.on('error', () => {
  // Shit breaks so handling error is the way to go
  process.exit(0);
});

child.on('exit', () => {
  // And in case shit works, which is unlikely
  process.exit(0);
});

require('readline')
  .createInterface({ input: process.stdin, output: process.stdout })
  .on('line', line => {
    write(line);
  });
