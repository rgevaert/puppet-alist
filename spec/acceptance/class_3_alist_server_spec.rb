require 'spec_helper_acceptance'

describe 'alist::server class', :node => :alist_server do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'alist::server': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest_on('alist_server', pp, :catch_failures => true)
      apply_manifest_on('alist_server', pp, :catch_failures => true)
    end

    server_line = 'SERVER=' + fact_on('alist_server','hostname') + '.' + fact_on('alist_server','domain')
    config = '/etc/alist/server.cf'

    describe file("#{config}") do
    it { should be_file }
      its(:content) { should match server_line }
    end

    describe package('alist-web') do
      it { is_expected.to be_installed }
    end

    describe package('alist-server') do
      it { is_expected.to be_installed }
    end

    describe service('alist-server') do
      it { is_expected.to be_enabled }
    end

    describe process('alistd') do
      its(:count) { should eq 1 }
    end


  end
end
