afinn = load 'safinn.txt' as (word:chararray, ratio: int);
grams = load 's5grams.txt' as (w1: chararray, w2: chararray, w3: chararray, w4: chararray, year: int, pages: int, books: int);
G = FOREACH grams GENERATE w1, year, CONCAT(w1,' ') as c1, CONCAT(w2, ' ') as c2, CONCAT(w3, ' ') as c3, w4;
T1 = FOREACH G GENERATE w1, year, CONCAT(c1,c2) as c12, c3, w4;
T2 = FOREACH T1 GENERATE w1, year, CONCAT(c12,c3) as c123, w4;
T3 = FOREACH T2 GENERATE w1, year, CONCAT(c123,w4) as sentence;
sentences = FOREACH T3 GENERATE w1 as w1, year as year, FLATTEN(TOKENIZE(sentence)) as w;
A = JOIN afinn BY (word), sentences by w USING 'replicated';
B = FOREACH A GENERATE w1, year, afinn::ratio as ratio;
C = GROUP B BY (w1, year);
FINAL = FOREACH C GENERATE group, SUM(B.ratio);
dump FINAL;


--- Load real dataset
fgrams = load '5grams.txt' as (sentence: chararray, year: int, pages: int, books: int);
afinn = load 'afinn.txt' as (word:chararray, ratio: int);
grams = FOREACH fgrams GENERATE LOWER(STRSPLIT(sentence, ' ').$0) as w1, year, LOWER(sentence) as sentence;
lgrams = FILTER grams BY (w1 == 'i') OR (w1 == 'I');

sentences = FOREACH lgrams GENERATE w1 as w1, year as year, FLATTEN(TOKENIZE(sentence)) as w;
A = JOIN afinn BY (word), sentences by w USING 'replicated';
B = FOREACH A GENERATE w1, year, afinn::ratio as ratio;
C = GROUP B BY (w1, year);
FINAL = FOREACH C GENERATE group, AVG(B.ratio) as avg_ratio;
dump FINAL;
