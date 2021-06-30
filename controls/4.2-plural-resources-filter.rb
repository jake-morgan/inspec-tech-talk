aws_s3_buckets.where(tags: {"Environment" => "Dev"}).bucket_names.each do |bucket_name|
  describe aws_s3_bucket(bucket_name) do
    it { should_not be_public }
    it { should have_default_encryption_enabled }
    it { should have_versioning_enabled }
  end
end
