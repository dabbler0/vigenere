Vigenere Cryptanalysis
----------------------

`./src/train.coffee ./data_train/` where `./data_train` is a directory will generate a new set of English statistics using the given training data. The current statistics were trained off a couple books and the texts in the Open American National Corpus.

`./src/guess-key.coffee ciphertext.txt` will output the estimated key. So far this has worked 100% of the time.

`./src/test.coffee ./data_test/` runs a thousand tests on random substrings from files in a directory.

Most of the cryptanalysis code is in `src/cryptanalysis.coffee`. Broadly, the cryptanalysis works as follows:
  - We always estimate the probablity of any given document as the product of the probabilities of all the letters in it. This makes it easy to compute.
  1. For each possible key length, we look at each character in the key, and choose the character that would maximize the probabilities that that character is associated with. This generates a most probable key for each key length. Because we assume the characters are independent of each other (we estimate them only based on the parts of the ciphertext that they are encrypting -- so like every nth letter), this only takes 27 * n time, or O(n).
  2. We pick the key length that generates the most probable plaintext.

This algorithm succeeds with 100% accuracy on everything I have tested it on so far and runs in O(n + k) on the message length/maximum key length.
