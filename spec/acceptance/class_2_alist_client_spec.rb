require 'spec_helper_acceptance'

describe 'alist::client class', :node => 'alist_client' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'alist::client': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('alist-client') do
      it { is_expected.to be_installed }
    end

    server_line = "SERVER=alist." + fact('domain')
    config = '/etc/alist/client.cf'

    describe file("#{config}") do
    it { should be_file }
      its(:content) { should match server_line }
    end

    describe package('alist-web') do
      it { is_expected.not_to be_installed }
    end

    describe package('alist-server') do
      it { is_expected.not_to be_installed }
    end

    describe service('alist-server') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end
  end
end
