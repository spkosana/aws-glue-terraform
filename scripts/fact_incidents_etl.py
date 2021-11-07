import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job


args = getResolvedOptions(
    sys.argv, ['JOB_NAME', 'SOURCE_S3_LOCATION', 'DESTINATION_S3_LOCATION'])
SOURCE_S3_LOCATION = args['SOURCE_S3_LOCATION']
DESTINATION_S3_LOCATION = args['DESTINATION_S3_LOCATION']
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

fact_incidents = glueContext.create_dynamic_frame_from_options(
    connection_type="s3",
    connection_options={
        "paths": [SOURCE_S3_LOCATION]
    },
    format="parquet",
    additional_options={"useS3ListImplementation": True},
    transformation_ctx="fact_incidents")

partitionedDf = fact_incidents.repartition(2)

fact_incidents_partitioned = glueContext.write_dynamic_frame.from_options(
    frame=partitionedDf,
    connection_type="s3",
    connection_options={
        "path": DESTINATION_S3_LOCATION},
    format="glueparquet", transformation_ctx="fact_incidents_partitioned")

job.commit()
