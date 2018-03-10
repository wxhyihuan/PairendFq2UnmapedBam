workflow PairendFqtoUnmappedBam_wdl{
  File inputSamplesFile
  String utilsdir
  String gatk_path
  #0  1 2 3 4 5 6 7 8 9 10  11  12
  #samleid  readgroup_name  library_name  ReadLen1,Readlen2 InsertSize  DataSize(M) platform_unit run_date  platform_name sequencing_center cellid  fq1 fq2
  #Array[Array[String]] metainfos=read_tsv(PeFq2BamMetaCheck.cleanmetainfo)

  call MetaInfoCheck as PeFq2BamMetaCheck{
    input :
      inputtable = inputSamplesFile,
      utilsdir = utilsdir
  }

  scatter (metadata in PeFq2BamMetaCheck.cleanmetainfostr){
    call PairendFastQsToUnmappedBAM {
      input :
        gatk_path = gatk_path,
        fastq_1 = metadata[11],
        fastq_2 = metadata[12],
        readgroup_name = metadata[1],
        sample_name = metadata[0],
        library_name = metadata[2],
        platform_unit = metadata[6],
        run_date = metadata[7],
        platform_name = metadata[8],
        sequencing_center = metadata[9]
    }
  }

  call FqtoBamMetainfo{
    input :
      unmapped_bams = PairendFastQsToUnmappedBAM.output_bams,
      sample_names = PairendFastQsToUnmappedBAM.sample_names,
      readgroup_names = PairendFastQsToUnmappedBAM.readgroup_names,
      utilsdir = utilsdir
  }
  
}

task PairendFastQsToUnmappedBAM {
  String fastq_1
  String fastq_2
  String readgroup_name
  String sample_name
  String library_name
  String platform_unit
  String run_date
  String platform_name
  String sequencing_center
  
  String gatk_path

  command {
    ${gatk_path} --java-options "-Xmx3000m" \
      FastqToSam \
        --FASTQ ${fastq_1} \
        --FASTQ2 ${fastq_2} \
        --OUTPUT ${readgroup_name}.unmapped.bam \
        --READ_GROUP_NAME ${readgroup_name} \
        --SAMPLE_NAME ${sample_name} \
        --LIBRARY_NAME ${library_name} \
        --PLATFORM_UNIT ${platform_unit} \
        --RUN_DATE ${run_date} \
        --PLATFORM ${platform_name} \
        --SEQUENCING_CENTER ${sequencing_center}
  }

  output {
    File output_bams = "${readgroup_name}.unmapped.bam"
    String sample_names = "${sample_name}"
    String readgroup_names = "${readgroup_name}"
  }

}

task MetaInfoCheck {
  String inputtable
  String utilsdir
  command {
    perl ${utilsdir}/metainfo_check.pl ${inputtable} MetaInfoCheck.out.tsv
  }
  output {
    File cleanmetainfo = "MetaInfoCheck.out.tsv"
    Array[Array[String]] cleanmetainfostr = read_tsv("MetaInfoCheck.out.tsv")
  }
}

task FqtoBamMetainfo{
  String utilsdir
  Array[String] unmapped_bams
  Array[String] sample_names
  Array[String] readgroup_names
  
  command <<<
    set -e
    set -o pipefail
    
    python << CODE
    unmapped_bams = ['${sep="','" unmapped_bams}']
    readgroup_names = ['${sep="','" readgroup_names}']
    sample_names = ['${sep="','" sample_names}']

    if len(unmapped_bams)!= len(readgroup_names):
      exit(1)

    with open("sample_rg_unmapped_bams.tsv", "w") as fi:
      for i in range(len(readgroup_names)):
        fi.write(sample_names[i] + "\t" + readgroup_names[i] + "\t" + unmapped_bams[i] + "\n")

    CODE
    
    perl ${utilsdir}/convertfq2baminfotosamplebamlists.pl sample_rg_unmapped_bams.tsv
  >>>

  output {
    Array[File] samplebamlists = glob("*.list")
  }
}
