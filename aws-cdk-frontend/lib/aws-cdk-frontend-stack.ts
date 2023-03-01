import { Stack, StackProps } from "aws-cdk-lib";
import { Construct } from "constructs";
import * as cdk from "aws-cdk-lib";
import * as s3 from "aws-cdk-lib/aws-s3";
import * as s3Deployment from "aws-cdk-lib/aws-s3-deployment";
import * as route53 from "aws-cdk-lib/aws-route53";
// import * as sqs from 'aws-cdk-lib/aws-sqs';

export class MinaCdkFrontendStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const frontendBucket = new s3.Bucket(this, "frontend", {
      bucketName: "mina-frontend-cdk.feb23.tu.devfactory.com",
      publicReadAccess: true,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      websiteIndexDocument: "index.html",
    });

    const deployment = new s3Deployment.BucketDeployment(
      this,
      "deployStaticWebsite",
      {
        sources: [s3Deployment.Source.asset("/workspace/tu-feb-2023--mina-ad-mina/aws-cdk-frontend/Intro-to-UI")],
        destinationBucket: frontendBucket,
      }
    );

    const zone = route53.HostedZone.fromLookup(this, "baseZone", {
      domainName: "feb23.tu.devfactory.com",
    });

    const cName = new route53.CnameRecord(this, "test.baseZone", {
      zone: zone,
      recordName: "mina-frontend-cdk",
      domainName: frontendBucket.bucketWebsiteDomainName,
    });

    // The code that defines your stack goes here

    // example resource
    // const queue = new sqs.Queue(this, 'AwsCdkFrontendQueue', {
    //   visibilityTimeout: cdk.Duration.seconds(300)
    // });
  }
}