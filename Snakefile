SAMPLE="SRR292770"

rule all:
   input:
         expand("trimmed/{sample}_1.unpaired.fastq.gz", sample=SAMPLE)  

rule trimmomatic_pe:
    input:
        r1="{sample}_1.fastq.gz",
        r2="{sample}_1.fastq.gz"
    output:
        r1="trimmed/{sample}_1.fastq.gz",
        r2="trimmed/{sample}_2.fastq.gz",
        # reads where trimming entirely removed the mate
        r1_unpaired="trimmed/{sample}_1.unpaired.fastq.gz",
        r2_unpaired="trimmed/{sample}_2.unpaired.fastq.gz"
    log:
        "logs/trimmomatic/{sample}.log"
    params: 
        adapter = "TruSeq2-PE.fa"
    threads: 2
    log:
        "logs/trimmomatic/{sample}.log"
    benchmark:
        "benchmarks/trimmomatic/{sample}.benchmark.txt"
    shell:
      "trimmomatic PE -threads {threads} -phred33 "
      "{input.r1} {input.r1} {output.r1} {output.r1_unpaired} {output.r2} {output.r2_unpaired} "
      "ILLUMINACLIP:{params.adapter}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 2> {log}"
