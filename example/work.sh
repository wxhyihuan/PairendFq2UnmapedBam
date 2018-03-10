java -jar /prt1/puluotong/PMO/wangxh/Software/src/WorkflowDL/wdltool-0.14.jar inputs PairendFqtoUnmappedBam.wdl >PairendFqtoUnmappedBam.test4.json
#修改WDL_fqfilter.test4.json
#注意 fqtobammetainfo 中的run_date 日期格式为 2018-02-09 形式(其他形式如 2018/02/09 在GATK中是无法识别使用的)

java -jar /prt1/puluotong/PMO/wangxh/Software/src/WorkflowDL/cromwell-30.1.jar run PairendFqtoUnmappedBam.wdl --inputs PairendFqtoUnmappedBam.test4.json