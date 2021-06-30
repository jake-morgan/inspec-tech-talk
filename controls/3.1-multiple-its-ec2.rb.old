# https://docs.chef.io/inspec/resources/aws_ec2_instance/

describe aws_ec2_instance(name: 'my-instance') do
  it { should exist }
  it { should be_running }
  its('tags_hash') { should include('CostCenter') }
  its('launch_time') { should cmp > Time.now - (60 * 60 * 24 * 30) }
end
