import sys
import nltk.data
import re

# Print all 5-grams from the file specified by command-line argument

punct = re.compile(r'^[^A-Za-z0-9]+|[^a-zA-Z0-9]+$')
is_word=re.compile(r'[a-z]', re.IGNORECASE)

sentence_tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')
word_tokenizer=nltk.tokenize.punkt.PunktWordTokenizer()

def get_words(sentence):
    return [punct.sub('',word) for word in word_tokenizer.tokenize(sentence) if is_word.search(word)]

def ngrams(text, n):
    for sentence in sentence_tokenizer.tokenize(text.lower()):
        words = get_words(sentence)
        for i in range(len(words)-(n-1)):
            yield(' '.join(words[i:i+n]))

def extract_gutenberg_text(filename):
    fp = open(filename)
    lines = fp.readlines()
    fp.close()
    started = False
    data = ""
    for line in lines:
        if started:
            data += line + "\n"
        if "START OF THIS PROJECT GUTENBERG" in line:
            started = True
        if "END OF THIS PROJECT GUTENBERG EBOOK" in line:
            started = False
    return data

def print_ngrams(data, ngram_size):
    for sentence in sentence_tokenizer.tokenize(data):
        for ngram in ngrams(sentence, ngram_size):
            print ngram

if __name__ == '__main__':
  data = extract_gutenberg_text(sys.argv[1])
  print_ngrams(data, 5)


