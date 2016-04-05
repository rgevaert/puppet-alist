require 'spec_helper'

describe 'alist' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "alist class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('alist::params') }
          it { is_expected.to contain_class('alist::install').that_comes_before('alist::config') }
          it { is_expected.to contain_class('alist::config') }
          it { is_expected.to contain_class('alist::service').that_subscribes_to('alist::config') }

          it { is_expected.to contain_service('alist') }
          it { is_expected.to contain_package('alist').with_ensure('present') }
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

      it { expect { is_expected.to contain_package('alist') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
