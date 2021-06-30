# https://docs.chef.io/inspec/resources/aws_s3_bucket/

describe aws_s3_bucket("my-bucket") do
  it { should_not be_public }
  it { should have_default_encryption_enabled }
  it { should have_versioning_enabled }
end
