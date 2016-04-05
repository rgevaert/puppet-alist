require 'spec_helper'

$default_client_cf = <<EOF
# This file is managed with puppet

# Script that controls if we want to start alistd.

ALIST_START_ON_BOOT=false
ALIST_START_ON_SHUTDOWN=false
ALIST_OPTS="-D 0 &"
EOF
$client_cf = ""

describe 'alist::client', :type => :class do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "alist::client class" do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('alist::client') }

          it { is_expected.to contain_class('alist::params') }
          it { is_expected.to contain_package('alist-client').with_ensure('present') }
          it { is_expected.to contain_file('/etc/alist/client.cf').with(
            'ensure'  => 'present',
            'owner'   => 'root',
            'group'   => 'root',
            'mode'    => '0644',
          )}
          it { is_expected.to contain_file('/etc/alist/client.cf').that_requires('Package[alist-client]') }
          it { is_expected.to contain_file('/etc/default/alist-client').with(
            'ensure' => 'present',
            'owner'  => 'root',
            'group'  => 'root',
            'mode'   => '0644',
          )}
          it { is_expected.to contain_file('/etc/default/alist-client').with_content($default_client_cf)
          }
          it { is_expected.to contain_file('/etc/default/alist-client').that_requires('Package[alist-client]') }

          context "without any parameters" do
            let(:facts) do
              super().merge({ :domain => 'example.net' })
            end
            it {
                is_expected.to contain_file('/etc/alist/client.cf').with_content(/SERVER=alist\.example\.net/)
            }
          end

          context "with parameters" do
            let(:params) {{ :alist_server => 'myalisthost.com' }}
            it { is_expected.to contain_file('/etc/alist/client.cf').with_content(/SERVER=myalisthost\.com/)
            }
          end
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'alist class without any parameters on Solaris/Nexenta' do
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
