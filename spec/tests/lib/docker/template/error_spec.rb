# Frozen-string-literal: true
# Copyright: 2015 Jordon Bedwell - Apache v2.0 License
# Encoding: utf-8

require "rspec/helper"
describe Docker::Template::Error do
  it { is_expected.to have_const :BadRepoName }
  it { is_expected.to have_const :BadExitStatus }
  it { is_expected.to have_const :NoRootfsCopyDir }
  it { is_expected.to have_const :InvalidRepoType }
  it { is_expected.to have_const :NoSetupContextFound}
  it { is_expected.to have_const :InvalidTargzFile }
  it { is_expected.to have_const :NotImplemented }
  it { is_expected.to have_const :NoRootfsMkimg }
  it { is_expected.to have_const :RepoNotFound }
end
