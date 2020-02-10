configfile: "/projects/verhaak-lab/amins_cgp_level2/copy_number/TitanCNA/scripts/snakemake/config/config.yaml"
## add more configs, and overrides configs from the top for matching variables, if any
configfile: "/projects/verhaak-lab/amins_cgp_level2/copy_number/TitanCNA/scripts/snakemake/config/samples.yaml"

## TODO: prefer setting workdir via commandline instead of hardcoding in config file
workdir: config["workdir"]

include: "/projects/verhaak-lab/amins_cgp_level2/copy_number/TitanCNA/scripts/snakemake/ichorCNA.snakefile"
include: "/projects/verhaak-lab/amins_cgp_level2/copy_number/TitanCNA/scripts/snakemake/getAlleleCounts.snakefile"
import os.path

CHRS = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,'X']
CLUST = {1:[1], 2:[1,2], 3:[1,2,3], 4:[1,2,3,4], 5:[1,2,3,4,5], 6:[1,2,3,4,5,6], 7:[1,2,3,4,5,6,7], 8:[1,2,3,4,5,6,7,8], 9:[1,2,3,4,5,6,7,8,9], 10:[1,2,3,4,5,6,7,8,9,10]}
PLOIDY = {2:[2], 3:[2,3], 4:[2,3,4]}

rule all:
	input: 
		expand("results/titan/hmm/titanCNA_ploidy{ploidy}/{tumor}_cluster{clustNum}.titan.txt", tumor=config["pairings"], clustNum=CLUST[config["TitanCNA_maxNumClonalClusters"]], ploidy=PLOIDY[config["TitanCNA_maxPloidy"]]),
		#expand("results/titan/hmm/titanCNA_ploidy{ploidy}/", ploidy=PLOIDY[config["TitanCNA_maxPloidy"]]),
		"results/titan/hmm/optimalClusterSolution.txt"
		
rule makeOutDir:
	output:
		"results/titan/hmm/titanCNA_ploidy{ploidy}/dummydir.txt"
	params:
		mem=config["std_mem"],
		runtime=config["std_runtime"],
		pe=config["std_numCores"]
	shell:
		"ls >> {output}"
		
rule runTitanCNA:
	input:
		alleleCounts="results/titan/tumCounts/{tumor}.tumCounts.txt",
		corrDepth="results/ichorCNA/{tumor}/{tumor}.correctedDepth.txt"		
	output:
		titan="results/titan/hmm/titanCNA_ploidy{ploidy}/{tumor}_cluster{clustNum}.titan.txt",
		param="results/titan/hmm/titanCNA_ploidy{ploidy}/{tumor}_cluster{clustNum}.params.txt",
		segTxt="results/titan/hmm/titanCNA_ploidy{ploidy}/{tumor}_cluster{clustNum}.segs.txt",
		seg="results/titan/hmm/titanCNA_ploidy{ploidy}/{tumor}_cluster{clustNum}.seg",
		outRoot=directory("results/titan/hmm/titanCNA_ploidy{ploidy}/{tumor}_cluster{clustNum}")
	params:
		titanRscript=config["TitanCNA_rscript"],
		libdir=config["TitanCNA_libdir"],
		numCores=config["TitanCNA_numCores"],
		normal=config["TitanCNA_normalInit"],
		chrs=config["TitanCNA_chrs"],
		chrsTrain=config["ichorCNA_chrTrain"],
        chrsNormalize=config["ichorCNA_chrTrain"],
		genomeStyle=config["genomeStyle"],
		genomeBuild=config["genomeBuild"],
		cytobandFile=config["cytobandFile"],
		estimatePloidy=config["TitanCNA_estimatePloidy"],
		estimateClonality=config["TitanCNA_estimateClonality"],
		estimateNormal=config["TitanCNA_estimateNormal"],
		centromere=config["centromere"],
		alphaK=config["TitanCNA_alphaK"],
		#alphaR=config["TitanCNA_alphaR"],
		#alleleModel=config["TitanCNA_alleleModel"],
		txnExpLen=config["TitanCNA_txnExpLen"],
		plotYlim=config["TitanCNA_plotYlim"],
		gender=config["TitanCNA_gender"],
		verbosity=config["TitanCNA_verbosity"],
		hetHeader=config["TitanCNA_hetHeader"],
		centFlankLength=config["TitanCNA_centFlankLength"],
		mapWig=config["ichorCNA_mapWig"],
		speciesID=config["ichorCNA_species"],
		mem=config["TitanCNA_mem"],
		runtime=config["TitanCNA_runtime"],
		pe=config["TitanCNA_pe"],
		drawPlots=config["TitanCNA_drawPlots"]
	log:
		"logs/titan/hmm/titanCNA_ploidy{ploidy}/{tumor}_cluster{clustNum}.log"
	shell:
		"""
		mkdir -p {output.outRoot} && Rscript {params.titanRscript} --hetFile {input.alleleCounts} --hetHeader {params.hetHeader} --cnFile {input.corrDepth} --outFile {output.titan} --outSeg {output.segTxt} --outParam {output.param} --outIGV {output.seg} --outPlotDir {output.outRoot} --libdir {params.libdir} --id {wildcards.tumor} --numClusters {wildcards.clustNum} --numCores {params.numCores} --normal_0 {params.normal} --ploidy_0 {wildcards.ploidy} --chrs \"{params.chrs}\" --chrsNormalize \"{params.chrsNormalize}\" --estimateNormal {params.estimateNormal} --estimatePloidy {params.estimatePloidy} --estimateClonality {params.estimateClonality}  --centromere {params.centromere} --alphaK {params.alphaK} --txnExpLen {params.txnExpLen} --plotYlim \"{params.plotYlim}\" --gender {params.gender} --genomeStyle {params.genomeStyle} --verbose {params.verbosity} --centFlankLength {params.centFlankLength} --mapWig {params.mapWig} --speciesID {params.speciesID} --genomeBuild {params.genomeBuild} --cytobandFile {params.cytobandFile} --drawPlots {params.drawPlots} > {log} 2> {log}
		"""
					
rule selectSolution:
	input:
		ploidyDirs=expand("results/titan/hmm/titanCNA_ploidy{ploidy}/dummydir.txt", ploidy=PLOIDY[config["TitanCNA_maxPloidy"]]),
		resultFiles=expand("results/titan/hmm/titanCNA_ploidy{ploidy}/{tumor}_cluster{clustNum}.titan.txt", tumor=config["pairings"], clustNum=CLUST[config["TitanCNA_maxNumClonalClusters"]], ploidy=PLOIDY[config["TitanCNA_maxPloidy"]])
	output:
		"results/titan/hmm/optimalClusterSolution.txt"
	params:
		solutionRscript=config["TitanCNA_selectSolutionRscript"],
		threshold=config["TitanCNA_solutionThreshold"],
		mem=config["std_mem"],
		runtime=config["std_runtime"],
		pe=config["std_numCores"]
	log:
		"logs/titan/selectSolution.log"
	shell:
		"""
		if [ -d results/titan/hmm/titanCNA_ploidy2/ ]; then
			ploidyRun2=results/titan/hmm/titanCNA_ploidy2/
		else
			ploidyRun2=NULL
		fi

		if [ -d results/titan/hmm/titanCNA_ploidy3/ ]; then
			ploidyRun3=results/titan/hmm/titanCNA_ploidy3/
		else
			ploidyRun3=NULL
		fi

		if [ -d results/titan/hmm/titanCNA_ploidy4/ ]; then
			ploidyRun4=results/titan/hmm/titanCNA_ploidy4/
		else
			ploidyRun4=NULL
		fi

		Rscript {params.solutionRscript} --ploidyRun2 $ploidyRun2 --ploidyRun3 $ploidyRun3 --ploidyRun4 $ploidyRun4 --threshold {params.threshold} --outFile {output} > {log} 2> {log}
		"""

#	run:
#		if "results/titan/hmm/titanCNA_ploidy3" in input:
#			ploidyRun3 = input[1]
#		else:
#			ploidyRun3 = "NULL"
#		if "results/titan/hmm/titanCNA_ploidy4" in input:
#			ploidyRun4 = input[2]
#		else:
#			ploidyRun4 = "NULL"	
#		os.system("Rscript params.solutionRscript --ploidyRun2 input[0] --ploidyRun3 ploidyRun3 --ploidyRun4 ploidyRun4 --threshold params.threshold --outFile output")

		
