describe command("aws --version") do
  its('stdout') { should match "#{input('awscli_version')}" }
end

describe command("aws-vault --version  2>&1 | tee vaultver && cat vaultver") do
  its('stdout') { should match "#{input('awsvault_version')}" }
end