configfile: "/projects/verhaak-lab/amins_cgp_level2/copy_number/TitanCNA/scripts/snakemake/config/config.yaml"
## add more configs, and overrides configs from the top for matching variables, if any
configfile: "/projects/verhaak-lab/amins_cgp_level2/copy_number/TitanCNA/scripts/snakemake/config/samples.yaml"

CHRS = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,'X']

rule tumCounts:
	input: 
		expand("results/titan/tumCounts/{tumor}/{tumor}.tumCounts.chr{chr}.txt", tumor=config["pairings"], chr=CHRS),		
		expand("results/titan/tumCounts/{tumor}.tumCounts.txt", tumor=config["pairings"])
	
rule getHETsites:
	input:
		lambda wildcards: config["samples"][config["pairings"][wildcards.tumor]]
	output:
		"results/titan/hetPosns/{tumor}/{tumor}.chr{chr}.vcf"
	params:
		refFasta=config["refFasta"],
		snpDB=config["snpVCF"],
		samtoolsCmd=config["samTools"],
		mem=config["std_mem"],
		runtime=config["std_runtime"],
		pe=config["std_numCores"]
	log:
		"logs/titan/hetPosns/{tumor}/{tumor}.chr{chr}.log"
	shell:
		"{params.samtoolsCmd} mpileup -uv -I -f {params.refFasta} -r {wildcards.chr} -l {params.snpDB} {input} | bcftools call -v -c - | grep -e '0/1' -e '#' > {output} 2> {log}"


rule getAlleleCountsByChr:
	input:
		hetSites="results/titan/hetPosns/{tumor}/{tumor}.chr{chr}.vcf",
		tumBam=lambda wildcards: config["samples"][wildcards.tumor]
	output:
		"results/titan/tumCounts/{tumor}/{tumor}.tumCounts.chr{chr}.txt"
	params:
		countScript=config["pyCountScript"],
		#pyEnv=config["pyEnv"],
		#refFasta=config["refFasta"],
		mapQ=config["map_quality"],
		baseQ=config["base_quality"],
		vcfQ=config["vcf_quality"],
		mem=config["std_mem"],
		runtime=config["std_runtime"],
		pe=config["std_numCores"]
	log:
		"logs/titan/tumCounts/{tumor}/{tumor}.chr{chr}.log"
	shell:
		"python {params.countScript} {wildcards.chr} {input.hetSites} {input.tumBam} {params.baseQ} {params.mapQ} {params.vcfQ} > {output} 2> {log}"

rule catAlleleCountFiles:
	input:
		expand("results/titan/tumCounts/{{tumor}}/{{tumor}}.tumCounts.chr{chr}.txt", chr=CHRS)
	output:
		"results/titan/tumCounts/{tumor}.tumCounts.txt"
	log:
		"logs/titan/tumCounts/{tumor}/{tumor}.cat.log"
	shell:
		"cat {input} | grep -v Chr > {output} 2> {log}"
