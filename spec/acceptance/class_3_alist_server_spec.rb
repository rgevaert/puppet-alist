require 'spec_helper_acceptance'

#describe 'alist::server class', :node => :alist_server do
describe 'alist::server class' do
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

#    server_line = 'SERVER=' + fact('hostname') + '.' + fact('domain')
#    config = '/etc/alist/server.cf'
#    command = "grep #{server_line} #{config}"
#    it 'server.cf SERVER param' do
#      on 'alist_server', command
#    end

    context 'alist-server role', :node => :alist_server do
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
end