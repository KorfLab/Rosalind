from math import log
# open file and parse
f = open('c_elegans.PRJNA13758.WS257.CDS_transcripts.fa')
f = f.read().split('>')
f = f[1:]
cds = {}
for x in f[:]:
    gene_id = x.split()[0]
    x = x.split('\n')
    seq = ''.join(x[1:])
    cds[gene_id] = [seq]
# initiate codon usage table
codon_usage = {
    'AAA': 0, 'AAU': 0, 'AAC': 0, 'AAG': 0, 'AUA': 0, 'AUU': 0, 'AUC': 0, 'AUG': 0,
    'ACA': 0, 'ACU': 0, 'ACC': 0, 'ACG': 0, 'AGA': 0, 'AGU': 0, 'AGC': 0, 'AGG': 0,
    'UAA': 0, 'UAU': 0, 'UAC': 0, 'UAG': 0, 'UUA': 0, 'UUU': 0, 'UUC': 0, 'UUG': 0,
    'UCA': 0, 'UCU': 0, 'UCC': 0, 'UCG': 0, 'UGA': 0, 'UGU': 0, 'UGC': 0, 'UGG': 0,
    'CAA': 0, 'CAU': 0, 'CAC': 0, 'CAG': 0, 'CUA': 0, 'CUU': 0, 'CUC': 0, 'CUG': 0,
    'CCA': 0, 'CCU': 0, 'CCC': 0, 'CCG': 0, 'CGA': 0, 'CGU': 0, 'CGC': 0, 'CGG': 0,
    'GAA': 0, 'GAU': 0, 'GAC': 0, 'GAG': 0, 'GUA': 0, 'GUU': 0, 'GUC': 0, 'GUG': 0,
    'GCA': 0, 'GCU': 0, 'GCC': 0, 'GCG': 0, 'GGA': 0, 'GGU': 0, 'GGC': 0, 'GGG': 0,
}
global_codon_usage = codon_usage.copy()
global_total_codon = 0.0
codon_list = codon_usage.keys()
for gene in cds:
    total_codon = 0.0
    # reset individual codon usage table
    i_codon_usage = codon_usage.copy()
    cds[gene][0] = cds[gene][0].replace('T', 'U')
    for pos in xrange(0, len(cds[gene][0]), 3):
        codon = cds[gene][0][pos:pos+3]
        i_codon_usage[codon] += 1
        global_codon_usage[codon] += 1
        total_codon += 1
        global_total_codon += 1
    # pseudocount
    if 0 in i_codon_usage.values():
        for i in i_codon_usage:
            i_codon_usage[i] += 1
            i_codon_usage[i] = i_codon_usage[i] / total_codon
    else:
        for i in i_codon_usage:
            i_codon_usage[i] = i_codon_usage[i] / total_codon
    cds[gene].append(i_codon_usage)
for i in global_codon_usage:
    global_codon_usage[i] = global_codon_usage[i] / global_total_codon
distance_list = []
for gene in cds:
    D = 0.0
    for i in codon_list:
        Pi = cds[gene][1][i]
        Qi = global_codon_usage[i]
        D += (Pi * log((Pi / Qi), 2))
    distance_list.append([gene, D])
sorted_dist = sorted(distance_list, key=lambda k: k[1])
min_10 = sorted_dist[:11]
max_10 = sorted_dist[-10:]
print 'Minimum distance genes:'
for i in min_10:
    print i[0], i[1]
print 'Maximum distance genes:'
for i in max_10:
    print i[0], i[1]
