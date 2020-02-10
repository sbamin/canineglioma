## mutect2 variant call filtering pipeline for CGP
## Author: @sbamin

if(!require(flowr))
	stop("Requirements not met; unable to load library: flowr")

if(!require(ultraseq))
	stop("Requirements not met; unable to load library: ultraseq")

if(!require(tidyverse))
	stop("Requirements not met; unable to load library: tidyverse")

##### PRIMARY FUNCTION TO MAKE FLOWMAT #####

## CRITICAL: Provide tumor and normal RGSM options identical to RGSM matching tumor and normal bam file, respectively.

flowr_cgp_filter_m2_calls <-function(mytm_bampath = mytm_bampath,
                                    mynr_bampath = mynr_bampath,
                                    mytm_rgsm = mytm_rgsm,
                                    mynr_rgsm = mynr_rgsm,
                                    sample_name = sample_name,
                                    filter_mode = "PAIRED"){
  
  # load configuration, command parameters from config file.
  opts_flow$load("flowr_cgp_filter_m2_calls.conf", check = TRUE)
  
  ## confirm git branch
  current_git_branch = system("git rev-parse --abbrev-ref HEAD", intern = TRUE)
  mygit_branch = opts_flow$get("mygit_branch")
  
  ## quit if git branch is not identical to one specified under mygit_branch
  if(current_git_branch != mygit_branch) {
    stop(sprintf("\ngit branch mismatch: workflow will not run unless mygit_branch in conf file matches current branch in the code repository\nmygit_branch is %s\ncurrent_git_branch is %s\nwork directory is %s\nmygit_path is %s\nwork directory must be underneath mygit_path and branch must be mygit_branch\n", mygit_branch, current_git_branch, getwd(), mygit_path))
  } else {
    print(sprintf("current git branch is: %s\nIt matches to conf git branch: %s\n",
                  current_git_branch, mygit_branch))
  }
  
  my_logs = opts_flow$get("my_logs_path")
  my_tmp_path = opts_flow$get("my_tmp_path")
  
  if(!dir.exists(my_logs)){
    message("creating log dir, ", my_logs)
    dir.create(path = my_logs, recursive = TRUE, mode = "0775")
  }
  
  if(!dir.exists(my_tmp_path)){
    message("creating tmp dir, ", my_tmp_path)
    dir.create(path = my_tmp_path, recursive = TRUE, mode = "0775")
  }
  
  if(!file.exists(mytm_bampath)) {
    stop(sprintf("\n##### ERROR #####\ntumor bam file does not exist at %s or not accessible.", mytm_bampath))
  }
  
  ## take care using && or || operator, esp. on a vector with length > 1
  ## Read https://stackoverflow.com/a/6559049/1243763
  if(filter_mode == "PAIRED") {
    if(!file.exists(mynr_bampath)) {
        stop(sprintf("\n##### ERROR #####\nnormal bam file does not exist at %s or not accessible.\nIf using tumor-only mode, set filter_mode to TONLY", mynr_bampath))
    } else {
        message(sprintf("\nfilter_mode: %s\nTumor bam: %s\nNormal bam: %s\nSAMPLE_NAME: %s\n", 
                    filter_mode, mytm_bampath, mynr_bampath, sample_name))
    }
  } else if(filter_mode == "TONLY") {
    message(sprintf("\nfilter_mode: %s\nTumor bam: %s\nSAMPLE_NAME: %s\n", 
                    filter_mode, mytm_bampath, sample_name))
  } else {
    stop("Invalid filter_mode: %s\nMust be one of PAIRED or TONLY", filter_mode)
  }
  
  time_tag <- "\"$(date +%d%b%y_%H%M%S%Z)\""
  
  ############################## Step 1: GEP PILEUP ##############################
  
  ## make output file based on number of intervals
  m2outid = sprintf("M2_filtered_%s", sample_name)
  
  if(filter_mode == "PAIRED") {
    mytmbam = sub(pattern = "\\.bam$", replacement = "", basename(path = mytm_bampath))
    
    get_pileup_tm = sprintf("%s %s GetPileupSummaries -R %s -I %s -V %s -O %s_%s_pileups.table %s && touch get_pileup_tm.done",
                             opts_flow$get("gatk4_wrapper_path"),
                             opts_flow$get("get_pileup_args1"),
                             opts_flow$get("genome_fasta_path"),
                             mytm_bampath,
                             opts_flow$get("germline_resource_dog10k_biallelic_path"),
                             m2outid,
                             mytmbam,
                             opts_flow$get("get_pileup_args2"))
    
    mynrbam = sub(pattern = "\\.bam$", replacement = "", basename(path = mynr_bampath))

    get_pileup_nr = sprintf("%s %s GetPileupSummaries -R %s -I %s -V %s -O %s_%s_pileups.table %s && touch get_pileup_nr.done",
                             opts_flow$get("gatk4_wrapper_path"),
                             opts_flow$get("get_pileup_args1"),
                             opts_flow$get("genome_fasta_path"),
                             mynr_bampath,
                             opts_flow$get("germline_resource_dog10k_biallelic_path"),
                             m2outid,
                             mynrbam,
                             opts_flow$get("get_pileup_args2"))        
  } else if(filter_mode == "TONLY") {
    mytmbam = sub(pattern = "\\.bam$", replacement = "", basename(path = mytm_bampath))
    
    get_pileup_tm = sprintf("%s %s GetPileupSummaries -R %s -I %s -V %s -O %s_%s_pileups.table %s && touch get_pileup_tm.done",
                             opts_flow$get("gatk4_wrapper_path"),
                             opts_flow$get("get_pileup_args1"),
                             opts_flow$get("genome_fasta_path"),
                             mytm_bampath,
                             opts_flow$get("germline_resource_dog10k_biallelic_path"),
                             m2outid,
                             mytmbam,
                             opts_flow$get("get_pileup_args2"))
    
    ## dummy instance to let flowr run
    get_pileup_nr = sprintf("sleep 60")
    
  } else {
    stop(sprintf("Invalid filter_mode: %s\nIt must be either PAIRED or TONLY", filter_mode))
  }

  
  ########################## Step 2: CALC CONTAMINATION ##########################
  
  contamin_table = sprintf("%s_%s_contamination.table", m2outid, filter_mode)
  
  if(filter_mode == "PAIRED") {
    calc_contamin = sprintf("%s %s CalculateContamination -I %s_%s_pileups.table --matched-normal %s_%s_pileups.table -O %s && touch calc_contamin_paired.done",
                            opts_flow$get("gatk4_wrapper_path"),
                            opts_flow$get("calc_contamin_args1"),
                            m2outid, mytmbam,
                            m2outid, mynrbam,
                            contamin_table)
  } else if(filter_mode == "TONLY") {
    calc_contamin = sprintf("%s %s CalculateContamination -I %s_%s_pileups.table -O %s && touch calc_contamin_tonly.done",
                            opts_flow$get("gatk4_wrapper_path"),
                            opts_flow$get("calc_contamin_args1"),
                            m2outid, mytmbam,
                            contamin_table)
  } else {
    stop(sprintf("Invalid filter_mode: %s\nIt must be either PAIRED or TONLY", filter_mode))
  }
  
  ###################### Step 3: FILTER M2 CALLS - STEP 1/2 ######################
  
  ## get raw vcf path
  if(filter_mode == "PAIRED") {
    ## assuming all vcfs are stored under common dir
    ## full path to somatic vcf from somatic runner paired mode
    final_m2pair_outid = sprintf("%s/paired/mutect2_paired_somatic_%s", opts_flow$get("m2_raw_vcfs_base_path"), sample_name)
    m2_somatic_vcf_path = sprintf("%s_snvindel_calls.vcf.gz", final_m2pair_outid)
  } else if(filter_mode == "TONLY") {
    ## full path to somatic vcf from somatic runner tonly mode
    final_m2tonly_outid = sprintf("%s/tonly/mutect2_tonly_somatic_%s", opts_flow$get("m2_raw_vcfs_base_path"), sample_name)
    m2_somatic_vcf_path = sprintf("%s_snvindel_calls.vcf.gz", final_m2tonly_outid)
  }
  
  if(!file.exists(m2_somatic_vcf_path)) {
    stop(sprintf("ERROR: Missing or inaccessible raw mutect2 vcf file at: %s\nTo debug: Check flowr_cgp_filter_m2_calls.R at Step 3\n", m2_somatic_vcf_path))
  }
  
  ## outid for step1 filtered vcf
  out_m2_filter_step1 = sprintf("%s_%s_step1of2_base.vcf.gz", m2outid, filter_mode)
  
  m2_s1_base_filter = sprintf("%s %s FilterMutectCalls -R %s -V %s --contamination-table %s -O %s %s && touch m2_s1_base_filter.done",
                          opts_flow$get("gatk4_wrapper_path"),
                          opts_flow$get("m2_step1_filter_args1"),
                          opts_flow$get("genome_fasta_path"),
                          m2_somatic_vcf_path,
                          contamin_table,
                          out_m2_filter_step1,
                          opts_flow$get("m2_step1_filter_args2"))
  
  ###################### Step 4: FILTER M2 CALLS - PASS 2/2 ######################
  
  ## outid for step2 filtered vcf: collect artifacts
  out_m2_collect_seqerr = sprintf("%s_%s_step2of2_seq_artifact_metrics", m2outid, filter_mode)
  
  m2_s2_collect_seqerr = sprintf("mkdir -p tmp_m2_s2 && %s %s CollectSequencingArtifactMetrics --TMP_DIR tmp_m2_s2 -R %s -I %s --DB_SNP %s --FILE_EXTENSION \".txt\" -O %s %s && touch m2_s2_collect_seqerr.done",
                            opts_flow$get("gatk4_wrapper_path"),
                            opts_flow$get("m2_step2_collect_seqerr_args1"),
                            opts_flow$get("genome_fasta_path"),
                            mytm_bampath,
                            opts_flow$get("dbsnp_path"),
                            out_m2_collect_seqerr,
                            opts_flow$get("m2_step2_collect_seqerr_args2"))

  ## outid for step2 filtered vcf: final m2 filtered vcf
  out_m2_final_oxog = sprintf("%s_%s_step2of2_oxog.vcf.gz", m2outid, filter_mode)
  
  m2_s2_oxog = sprintf("%s %s FilterByOrientationBias -AM G/T -AM C/T -R %s -V %s -P %s.pre_adapter_detail_metrics.txt -O %s %s && touch m2_s2_oxog.done",
                          opts_flow$get("gatk4_wrapper_path"),
                          opts_flow$get("m2_step2_oxog_args1"),
                          opts_flow$get("genome_fasta_path"),
                          out_m2_filter_step1,
                          out_m2_collect_seqerr,
                          out_m2_final_oxog,
                          opts_flow$get("m2_step2_oxog_args2"))

  ################################# FLOWR CONFIG #################################
  
    flownames = c(
      "get_pileup_tm", "get_pileup_nr",
      "calc_contamin",
      "m2_s1_base_filter",
      "m2_s2_collect_seqerr",
      "m2_s2_oxog"
    )
    
    jobnames = flownames
    
    cmds = c(get_pileup_tm, get_pileup_nr,
                  calc_contamin,
                  m2_s1_base_filter,
                  m2_s2_collect_seqerr,
                  m2_s2_oxog)
  
  flowmaster <- data.frame(rep(sample_name, length(cmds)), jobnames, cmds, stringsAsFactors = FALSE)
  colnames(flowmaster) <- c("samplename", "jobname", "cmd")
  
  ## give workflow a name: a UUID will be tagged by flowr to this name.
  flowid = sprintf("cgp_filter_m2_%s_%s", sample_name, filter_mode)
  
  ## make flowr compatible flowmat.
  myflowmat <- to_flowmat(x = flowmaster, samplename = sample_name)
  
  #rm(flownames, tm_table, nr_table, mutect, flowmaster)
  
  ## save all RData into logs directory
  myreports = sprintf("%s/flowr_%s", my_logs, flowid)
  
  if(!dir.exists(myreports)){
    message("creating log dir, ", myreports)
    dir.create(path = myreports, recursive = TRUE, mode = "0775")
  }
  
  ## pull flow def or sequence of commands to be run from code repository and plot workflow as pdf.
  flowdef = as.flowdef("flowr_cgp_filter_m2_calls.def")
  plot_flow(flowdef, pdf = TRUE, pdffile = file.path(myreports, sprintf("workflow_%s.pdf", flowid)))
  
  ## make flowr compatible list containing flowname and flowmat.
  ## flowr will use this list to run actual analysis pipeline using flowr::to_flow function.
  final_flow_object = list(flowmat = myflowmat, flowname = flowid)
  
  timetag = make.names(format(Sys.time(),"t%d_%b_%y_%H%M%S%Z"))
  mysessioninfo = sessionInfo()
  
  myinfomaster = list(envinfo = mysessioninfo, flowrmat = myflowmat, flowname = flowid)
  
  saveRDS(object = final_flow_object, file = sprintf("%s/cgp_filter_m2_calls_debug_flow_object_%s_%s.rds", myreports, flowid, timetag))
  saveRDS(object = myinfomaster, file = sprintf("%s/cgp_filter_m2_calls_sampleinfo_%s_%s.rds", myreports, flowid, timetag))
  
  return(list(flowmat = myflowmat, flowname = flowid))
}

## END ##
