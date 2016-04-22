require 'spec_helper_acceptance'

# Don't run the test when we don't provision.
# When alist-client is applied to default node
# this test always fails when BEAKER_provision is no
describe 'alist class', :if => ENV['BEAKER_provision'] == 'yes' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'alist': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('alist-client') do
      it { is_expected.not_to be_installed }
    end

    describe package('alist-web') do
      it { is_expected.not_to be_installed }
    end

    describe package('alist-server') do
      it { is_expected.not_to be_installed }
    end

  end
end
