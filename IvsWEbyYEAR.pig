--- Load real dataset
SET DEFAULT_PARALLEL 20;
grams_loaded = load '5grams.txt' as (sentence: chararray, year: int, pages: int, books: int);
afinn = load 'afinn.txt' as (word:chararray, ratio: int);
grams_filtered = FILTER grams_loaded BY sentence MATCHES '^([iI]|[wW]e)\\s+[a-z]+.*';
grams = FOREACH grams_filtered GENERATE LOWER(STRSPLIT(sentence, ' ').$0) as w1, year, LOWER(sentence) as sentence;
lgrams = grams;

sentences = FOREACH lgrams GENERATE w1 as w1, year as year, FLATTEN(TOKENIZE(sentence)) as w;
A = JOIN afinn BY (word), sentences by w USING 'replicated';
B = FOREACH A GENERATE w1, year, afinn::ratio as ratio;
C = GROUP B BY (w1, year);
FINAL = FOREACH C GENERATE group, AVG(B.ratio) as ratio_mean, COUNT(B.ratio) as ratio_count;
STORE FINAL INTO 'result.txt';
