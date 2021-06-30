admin_policies = [
  'AdministratorAccess',
  'SystemAdministrator',
  'CloudFormationStackSetsOrgAdminServiceRolePolicy'
] + input('admin-policies', value: [])

control 'EC2AdminInstanceRoleRuby' do
  impact 'high'
  title "Ensure no EC2 instances have admin roles."
  tag severity: 'High'

  aws_ec2_instances.instance_ids.each do |instance_id|
    role_name = aws_ec2_instance(instance_id).role

    next if role_name == nil

    admin_policies.each do |policy|
      describe aws_iam_role(role_name) do
        its('attached_policy_names') { should_not include policy }
      end
    end
  end
end
