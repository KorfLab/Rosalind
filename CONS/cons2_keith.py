"""
The main function that take in a fasta file and prints a consensus sequence.

The first argument is the name of that fasta file. You can also give it
one additional agrument which is the yaml file for the nucleic acid IUPAC
sequence conversion. However, if this argument is not given, it will
assume the file is in the current directory named 'nuc_code.yaml'.

An example call would be:
python cons2_keith.py test.fa

Please note: This does not do any error checking to see if the file is in the
correct format. Since it only prints something to the screen, the writer felt it
was unnecessary to put those error checks in. However, if you start creating
files with this script, please put those checks in place before proceding.
"""

import yaml
import sys


def scorecounts1(counts, rev_conv_dict):
    """
    First counts scoring algorithm. Initially made by Keith.

    :param counts: list of dicts containing count information
    :return: consensus sequence based on the scoring algorithm
    """
    finalseq = ''
    n = -1
    for item in counts:
        n += 1
        highest = 0
        highestletter = ''
        mixed = False
        # Get sequence
        for letter in sorted(item.iterkeys()):
            # print('letter: {}\t{}\t{}'.format(n, letter, item[letter]))
            if item[letter] > highest:
                if highest > 0:
                    mixed = True
                highest = item[letter]
                highestletter = letter
            elif item[letter] == highest:
                highestletter = '{}{}'.format(highestletter, letter)
            else:
                if item[letter] > 0:
                    mixed = True
        printletter = rev_conv_dict[highestletter]
        if mixed:
            printletter = printletter.lower()
        else:
            printletter = printletter.upper()
        finalseq = '{}{}'.format(finalseq, printletter)
    return(finalseq)


def scorecounts2(counts, rev_conv_dict):
    """
    Ian's counts scoring algorithm. Evolving based on consensus of the lab's
    feelings on how to call these bases.

    :param counts: list of dicts containing count information
    :return: consensus sequence based on the scoring algorithm
    """
    finalseq = ''
    n = -1
    for item in counts:
        n += 1
        highestletter = ''
        mixed = False

        # Get cutoffs as % of total counts
        total = 0
        for letter in sorted(item.iterkeys()):
            total += item[letter]
        include_cutoff = float(total * .25)
        include_count = 0
        lowercase_cutoff = float(total * .65)

        # Get sequence
        for letter in sorted(item.iterkeys()):
            print('letter: {}\t{}\t{}'.format(n, letter, item[letter]))
            if item[letter] >= include_cutoff:
                highestletter = '{}{}'.format(highestletter, letter)
                include_count += item[letter]

        if include_count <= lowercase_cutoff:
            mixed = True
        printletter = rev_conv_dict[highestletter]
        if mixed:
            printletter = printletter.lower()
        else:
            printletter = printletter.upper()
        finalseq = '{}{}'.format(finalseq, printletter)
        print(printletter)
    return(finalseq)


def main():
    fasta_file_name = str(sys.argv[1])
    yamlname = 'nuc_code.yaml'
    if len(sys.argv) > 2:
        yamlname = str(sys.argv[2])
    if len(sys.argv) > 3:
        print("Warning, arguments past {} are not used".format(yamlname))
    stream = file(yamlname, 'r')
    conv_dict = yaml.safe_load(stream)
    rev_conv_dict = {}
    for key in conv_dict:
        value = conv_dict[key]
        rev_conv_dict[value] = key
    counts = []
    with open(fasta_file_name, 'r') as fasta:
        for line in fasta:
            header = line[:-1]
            seq = next(fasta)[:-1]
            # Extends counts if size is not big enough to match seq size
            while len(counts) < len(seq):
                counts.append({'A': 0, 'C': 0, 'G': 0, 'T': 0})
            # Adds count information to counts
            n = 0
            for letter in seq:
                if letter in conv_dict:
                    weight = conv_dict[letter]
                    for base in weight:
                        counts[n][base] += 1*len(weight)
                else:
                    print('Warning, letter number {} in seq {} is not processed'
                          ' because {} does not exist in the lookup table'
                          .format(n, seq, letter))
                n += 1
    # Get consensus sequence
    finalseq = scorecounts1(counts, rev_conv_dict)
    print("Keith's consensus sequence:")
    print(finalseq)
    finalseq = scorecounts2(counts, rev_conv_dict)
    print("Ian's consensus sequence:")
    print(finalseq)



if __name__ == "__main__":
    main()

