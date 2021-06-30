control 'CIS-2.1.1' do
  impact 'high'

  title "Ensure all S3 buckets employ encryption-at-rest"

  desc 'Encrypting data at rest reduces the likelihood that it is
    unintentionally exposed and can nullify the impact of disclosure if the
    encryption remains unbroken.'

  tag severity: 'High'

  ref 'CIS Docs', url: 'https://www.cisecurity.org/benchmark/amazon_web_services/'

  aws_s3_buckets.bucket_names.each do |bucket_name|
    describe aws_s3_bucket(bucket_name) do
      it { should have_default_encryption_enabled }
    end
  end
end
