# PairendFq2UnmapedBam
使用GATK4 将pair end的fastq 文件处理成 unmaped 的bam文件，并将sample id, read group, run date sequence central等信息保留到bam文件中
Converts paired FASTQ to uBAM and adds read group information 

### 输入数据：
整理好得关于fastq信息的tab分表的表格文件，共13列（0~12）,各列的含义见下表第二列示意，注意
  1、没有的类可用-代替；
  2、readgroup不能重复出现，建议以 样品名_字母ID 形式；
  3、时间格式为 年-月-日 格式；
表格具体示例如下(文件名fqtobammetainfo.motifeddate.tsv)
```
#0	1	2	3	4	5	6	7	8	9	10	11	12
#samleid	readgroup_name	library_name	ReadLen1,Readlen2	InsertSize	DataSize(M)	platform_unit	run_date	platform_name	sequencing_center	cellid	fq1	fq2
NA12878	NA12878_A	Solexa-NA12878	100;100	300	50462	H06HDADXX130110.2.ATCACGAT	2016-9-1	Illumina	NRP	HWWMFBGX1	/Test/shard-0/execution/NA12878_A_1.fq.gz	/Test/shard-0/execution/NA12878_A_2.fq.gz
NA12878	NA12878_B	Solexa-NA12878	100;100	300	50462	H06HDADXX130110.1.ATCACGAT	2016-9-1	Illumina	NRP	HWWMFBGX2	/Test/shard-1/execution/NA12878_B_1.fq.gz	/Test/shard-1/execution/NA12878_B_2.fq.gz
NA12878	NA12878_C	Solexa-NA12878	100;100	300	50462	H06JUADXX130110.1.ATCACGAT	2016-9-1	Illumina	NRP	HWWMFBGX2	/Test/shard-2/execution/NA12878_C_1.fq.gz	/Test/shard-2/execution/NA12878_C_2.fq.gz
NA12812	NA12812_A	Solexa-NA12812	100;100	300	50462	H06HDADXX130119.2.ATCACGAT	2016-9-8	Illumina	NRP	HWWMFBGX1	/Test/shard-3/execution/NA12812_A_1.fq.gz	/Test/shard-3/execution/NA12812_A_2.fq.gz
NA12812	NA12812_B	Solexa-NA12812	100;100	300	50462	H06HDADXX130119.1.ATCACGAC	2016-9-8	Illumina	NRP	HWWMFBGX2	/Test/shard-4/execution/NA12812_B_1.fq.gz	/Test/shard-4/execution/NA12812_B_2.fq.gz
NA12812	NA12812_C	Solexa-NA12812	100;100	300	50462	H06JUADXX130119.1.ATCACGAC	2016-9-8	Illumina	NRP	HWWMFBGX2	/Test/shard-5/execution/NA12812_C_1.fq.gz	/Test/shard-5/execution/NA12812_C_2.fq.gz
```
### 输出
每个样品按照read group区分的bam文件

### 运行过程
#Run
首先需要得到wdl需要配置的参数信息
```sh
$ java -jar /prt1/puluotong/PMO/wangxh/Software/src/WorkflowDL/wdltool-0.14.jar inputs PairendFqtoUnmappedBam.wdl >PairendFqtoUnmappedBam.json
```
得到类似如下的json文件，将引号内的信息替换为相应的参数值，如下：
{
  "PairendFqtoUnmappedBam_wdl.PairendFastQsToUnmappedBAM.gatk_path": "~/gatk-4.0.2.0/gatk",
  "PairendFqtoUnmappedBam_wdl.utilsdir": "~/Utils",
  "PairendFqtoUnmappedBam_wdl.inputSamplesFile": "~/execution/fqtobammetainfo.motifeddate.tsv"
}

设置好后，运行即可：
```sh
$java -jar /cromwell-30.1.jar run PairendFqtoUnmappedBam.wdl --inputs PairendFqtoUnmappedBam.json
```
