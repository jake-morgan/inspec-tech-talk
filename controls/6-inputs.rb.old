admin_roles = input('admin_roles', value: ['InspecTechTalk'])

control 'EC2AdminInstanceRoleInput' do
  impact 'high'
  title "Ensure no EC2 instances have admin roles."
  tag severity: 'High'

  aws_ec2_instances.instance_ids.each do |instance_id|
    describe aws_ec2_instance(instance_id) do
      its('role') { should_not be_in admin_roles }
    end
  end
end
