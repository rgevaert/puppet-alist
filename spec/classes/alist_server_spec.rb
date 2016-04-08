require 'spec_helper'

describe 'alist::server', :type => :class do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "alist::server class" do
          let(:facts) do
            super().merge({ :fqdn => 'myhost.example.net' })
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('apache') }
          it { is_expected.to contain_class('alist::server') }
          it { is_expected.to contain_class('alist::params') }

          it { is_expected.to contain_package('alist-server').with(
            'ensure'  => 'present',
          )}

          it { is_expected.to contain_package('alist-web').with(
            'ensure'  => 'present',
            'require' => [ 'Package[alist-server]', 'Class[Apache]'],
          )}

          it { is_expected.to contain_file('/etc/alist/server.cf').with(
            'ensure'  => 'present',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'require' => 'Package[alist-server]',
            'content' => /SERVER=myhost\.example\.net/,
          )}

          it { is_expected.to contain_file('/etc/default/alist-server').with(
            'ensure'  => 'present',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'require' => 'Package[alist-server]',
            'content' => /^ALISTD_START=true$/,
          )}

          # apache config
          it { is_expected.to contain_file('/etc/apache2/conf.d/alist.conf').with(
            'ensure'  => 'present',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
            'require' => 'Package[alist-web]',
            'source'  => 'puppet:///modules/alist/apache.conf',
          )}

          # service config
          it { is_expected.to contain_service('alist-server').with(
            'hasrestart' => 'true',
            'hasstatus'  => 'false',
            'status'     => '/usr/bin/pgrep alistd',
            'require'    => [ 'File[/etc/default/alist-server]', 'File[/etc/alist/server.cf]'],
          )}

          context "without any parameters" do
            it { is_expected.to contain_service('alist-server').with_ensure('running') }
            it { is_expected.to contain_file('/etc/alist/server.cf').without_content(/^DENY_CLIENT=/) }
          end

          context "with parameter start_server set to false" do
            let(:params) {{
              :start_server => 'false',
            }}
            it { is_expected.to contain_file('/etc/default/alist-server').with_content(/^ALISTD_START=false$/) }
            it { is_expected.to contain_service('alist-server').with_ensure('stopped') }
          end

          context "with parameter deny_clients set to array of values" do
            let(:params) {{
              :deny_clients => [ '10.10.10.10', '11.11.11.11'],
            }}
            it { is_expected.to contain_file('/etc/alist/server.cf').with_content(/^DENY_CLIENT=10.10.10.10$/) }
            it { is_expected.to contain_file('/etc/alist/server.cf').with_content(/^DENY_CLIENT=11.11.11.11$/) }
          end

          context "with parameter deny_clients set to one value" do
            let(:params) {{
              :deny_clients => '10.10.10.10',
            }}
            it { is_expected.to contain_file('/etc/alist/server.cf').with_content(/^DENY_CLIENT=10.10.10.10$/) }
          end
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'alist::server class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('alist-client') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
